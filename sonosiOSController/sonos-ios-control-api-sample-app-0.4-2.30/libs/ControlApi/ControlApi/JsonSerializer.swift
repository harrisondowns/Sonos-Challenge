//
// The MIT License (MIT)
//
// Copyright (c) 2016 Sonos, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

open class BaseTrackDeserializer: NSObject, Serializable, NonNullable {
    static var trackTypes: [String: NSObject.Type] = ["track": Track.self, "podcast": Podcast.self, "audiobook": AudioBook.self]

    open func deserialize(_ object: ObjectType?) throws -> NSObject? {
        guard let properties = object as? [String : AnyObject] else {
            return self
        }

        let typeStr = properties["type"] as? String
        if let type = BaseTrackDeserializer.trackTypes[typeStr!] {
            if let deserializable = type.init() as? Serializable {
                return try deserializable.deserialize(properties as ObjectType?)
            }
        }
        return nil
    }
}

/**
 * This declaration allows us to put any kind of track into an item. The only caveat is that these track types must derive from
 * this empty class.
 */
public protocol BaseTrack: Serializable {
    var trackType: String? {get}
}

/* Mark some of the messages as NonNullable so nil fields are omitted when serialized */
extension Header: NonNullable {}
extension Service: NonNullable {}
extension PlayMode: NonNullable {}
extension PlaybackPolicy: NonNullable {}
extension NamespaceMetadata: NonNullable {}
extension Container: NonNullable {}
extension Artist: NonNullable {}
extension Album: NonNullable {}
extension QueueItem: NonNullable {}
extension Book: NonNullable {}
extension Item: NonNullable {}
extension Show: NonNullable {}
extension BaseBody: NonNullable {}
extension AudioBook: NonNullable {}
extension Podcast: NonNullable {}

/*
 * The following declarations pass back the class type for specialized fields in messages.
 */

/* Track types need to pass their exact type back when deserializing */
extension Track: BaseTrack, NonNullable {
    public var trackType: String? { return self.type }
}

/*
 * The following extension defines how all command and event messages will be serialized, deserialized. Since these messages have
 * an array that stores the header and body, we must explicitly serialize/deserialize these components.
 */
extension BaseMessage: NonNullable {
    public func serialize() -> NSObject? {
        return components.serialize()
    }

    public func deserialize(_ object: ObjectType?) throws -> NSObject? {
        if let components = object as? Array<NSDictionary> {
            self.components[0] = try self.header.deserialize(components[0])!
            self.components[1] = try self.body.deserialize(components[1])!
        }

        return self
    }
}

/**
 * This error type is thrown by the `JsonSerializer` to indicate errors while converting to/from JSON.
 */
public enum JsonError: Error {
    // This error is thrown when the serializer cannot convert an object to JSON.
    case jsonUnserializableError(message: String)
    // This error is thrown when the serializer cannot convert JSON to an object.
    case jsonUndeserializableError(message: String)
}

/**
 * This class serializes and deserializes objects to/from JSON using the Serializable protocol.
 */
public struct JsonSerializer {
    let typeToClassMap: [String: BaseMessage.Type] = ["playback:1.playbackStatus": Playback.PlaybackStatus.self,
        "playbackMetadata:1.metadataStatus": PlaybackMetadata.MetadataStatus.self,
        "global:1.groupCoordinatorChanged": Global.GroupCoordinatorChanged.self,
        "groupVolume:1.groupVolume": GroupVolume.GroupVolume.self,
        "playback:1.playbackError": Playback.PlaybackError.self,
        "globalError": GlobalErrorMessage.self // globalError can be returned for any namespace
        ]

    /**
     * This initializer takes a namespace for creating properties that are objects. This namespace should map to the name of a
     * module.
     */
    public init() {}

    /**
     * Converts an object to its JSON equivalent via the Serializable protocol. First it converts the object to an
     * `NSDictionary` and then passes this dictionary to the `NSJSONSerialization` class, which is written in Objective-C.
     *
     * - parameter object: The `Serializable` object that will be converted to JSON
     * - returns: A `String` with the JSON encoded in UTF-8
     * - throws: A `JsonError` if the object fails during serialization.
     */
    public func toJson(_ object: Serializable) throws -> String {
        let serialized = object.serialize()!

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: serialized, options: JSONSerialization.WritingOptions(rawValue: 0))
            return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        } catch {
            throw JsonError.jsonUnserializableError(message: "Unable to serialize \(object)")
        }
    }

    /**
     * Converts JSON to its object equivalent via the `Serializable` protocol. It first determines what Swift type is
     * represented in the JSON and then converts the object to an `NSDictionary` and then passes this dictionary to the
     * `NSJJSONSerialization` class, which is written in Objective-C.
     *
     * - parameter json: Has the JSON representation of an object.
     * - throws: A JsonError if the object fails during deserialization.
     */
    public func fromJson(_ json: String) throws -> BaseMessage? {
        do {
            let data = try _deserializeJson(json)
            if let object = _deserializeByType(data) {
                try _deserializeObject(data, object: object)
                return object
            }

            return nil
        } catch {
            throw JsonError.jsonUndeserializableError(message: "Unable to deserialize: \(json)")
        }
    }

    /**
     * Converts JSON to its object equivalent via the Serializable protocol. First it converts the object to an
     * `NSDictionary` and then passes this dictionary to the `NSJSONSerialization` class, which is written in Objective-C.
     *
     * - parameter json: Has the JSON representation of an object.
     * - parameter object: Will hold the property values in the JSON string.
     * - throws: A `JsonError`if the object fails during deserialization.
     */
    public func fromJson(_ json: String, object: Serializable) throws {
        do {
            let data = try _deserializeJson(json)
            try _deserializeObject(data, object: object)
        } catch {
            throw JsonError.jsonUndeserializableError(message: "Unable to deserialize: \(json)")
        }
    }

    /**
     * Converts a JSON string into an `NSDictionary`/`NSArray` object that can be converted into a
     * Control API message or type.
     *
     * - parameter json: Contains the message or type as a JSON String.
     * - returns: The `NSDictionary`/`NSArray` object with data read from the JSON string.
     */
    fileprivate func _deserializeJson(_ json: String) throws -> AnyObject {
        let jsonData = json.data(using: String.Encoding.utf8)
        return try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
    }

    /**
     * Deserializes an `NSDictionary`/`NSArray` object into a `Serializable` object.
     *
     * - parameter data: An `NSDictionary`/`NSArray` object with data that will be copied into a `Serializable` object.
     * - parameter object: The destination of data deserialized from data.
     */
    fileprivate func _deserializeObject(_ data: AnyObject, object: Serializable) throws {
        try object.deserialize(data as? ObjectType)
    }

    /**
     * Deserializes the type of a Control API message so that it can be deserialized to the proper Swift type.
     *
     * - parameter data: An `NSDictionary`/`NSArray` object with data that will be copied into a `Serializable` object.
     * - returns: A Control API message object matching the type found in data.
     */
    fileprivate func _deserializeByType(_ data: AnyObject) -> BaseMessage? {
        if let dataArray = data as? NSArray {
            let header = dataArray[0] as AnyObject
            if let namespace = header["namespace"] as? String, let type = header["type"] as? String {
                if let typeClass = typeToClassMap[namespace + "." + type] {
                    return typeClass.init()
                } else if let typeClass = typeToClassMap[type] {
                    return typeClass.init()
                }
            }
        }

        return nil
    }
}
