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

/**
 * This error type is for throwing exceptions from the default implementation of the Serializable protocol. The current types of
 * errors possible are unserializable types or properties not found while deserializing.
 */
public enum SerializationError: Error {
    // This error indicates that the type is not serializable, most likely because it does not have NSObject in its inheritance
    // chain.
    case typeUndeserializableError(message: String, type: Mirror)
    // This error indicates that the property does not exist as part of the member the object being deserialized.
    case noSuchPropertyError(message: String, type: Mirror)
}

// Type definition for brevity in the declarations below
public typealias ObjectType = NSObject

/**
 * This protocol indicates that the object being serialized should omit any properties in the encoded form that are nil. It does
 * not specify any methods but rather indicates that the default implementation of includeNonNull should return false.
 */
public protocol NonNullable { }

/**
 * This protocol specifies the minimum methods a type should implement in order to be serial/deserializable. For the purpose of
 * this protocol, serialization simply means turned into a dictionary structure. No on-the-wire representation is specified.
 * Therefore, any object serialized with this interface can be converted to forms, such as JSON or XML, that are then sent over
 * the wire.
 *
 * Two methods beyond serialization, handlePrimaryValue and includeNonNull, are also specified to overcome weaknesses of the Swift
 * implementation and allow for customization of the on-the-wire representation.
 */
public protocol Serializable {
    func getParameterTypes() -> [String: NSObject.Type]?

    /**
     * Serializes an object from its in-memory-format to a name-value pair, where value can be a dictionary, array,
     * or object format, that can then be converted to an on-the-wire format.
     *
     * - returns: A serialized object either in Dictionary, Array or other serializable form.
     */
    func serialize() -> NSObject?

    /**
     * Deserializes an object from name-value pairs into a native Object type. In normal use, an object comes over
     * the wire, is converted to a name-value object and then passed to this method to move the name-value pairs to the properties
     * of the object represented in the name-value pairs object.
     *
     * Because of the limited support for reflection in Swift (it's read only) all deserializable objects must directly or
     * indirectly inherit from `NSObject`. This allows any implementation to use the setValue: method of `NSObject` to actually
     * set the properties of the object.
     *
     * - parameter namespace: Contains the namespace of objects that are to be deserialized.
     * - parameter object: Contains the name-value object to be deserialized. This object is a `Dictionary` or an `Array`.
     * - returns: The object that was represented by the name-value pair object.
     */
    func deserialize(_ object: ObjectType?) throws -> NSObject?

    /**
     * Called to determine if a class wants nil values to be stored in the serialized format. If this method
     * returns true then properties with the value nil will not be inserted into the dictionary, otherwise it will be. Values that
     * are inserted when nil are actually inserted as an NSNull object since the Swift Dictionary does not store values that are
     * equal to nil.
     *
     * - returns: Either `true`, to indicate including `null` values, and `false` otherwise.
     */
    func includeNonNull() -> Bool
}

/**
 * This extension of the `Serializable` class represents the default implementation of the protocol. The goal of this
 * implementation is to return `nil` or throw errors for types that are not derived from NSObject. In addition, it provides
 * default implementations of `handlePrimaryValue` and `includeNonNull`, which return, by default, `false` and `true`
 * respectively.
 *
 * Other extensions may override these implementations to provide customization to specific classes or other related sets of
 * classes.
 */
extension Serializable {

    /**
     * The default implementation of this method returns `nil` for classes that do not derive since they are not deserializable.
     *
     * See `Serializable` protocol
     */
    func serialize() -> NSObject? {
        return nil
    }

    /**
     * The default implementation of this method throws a `TypeUnserialableError` for classes that are not derived from
     * `NSObject`.
     *
     * See `Serializable` protocol
     */
    public func deserialize(_ object: ObjectType?) throws -> NSObject? {
        throw SerializationError.typeUndeserializableError(message: "Type of object must derive from NSObject",
            type: Mirror(reflecting: self))
    }

    /**
     * The default implementation of this method returns true so that by default `nil` properties are serialized.
     *
     * See `Serializable` protocol
     */
    public func includeNonNull() -> Bool {
        return true
    }
}

/**
 * This extension overrides the implementation of `includeNonNull`. It returns `false` instead of `true`. The result is that
 * any class that indicates it's `NonNullable` will return false, all other classes will return true.
 */
extension Serializable where Self: NonNullable {
    /**
     * Returns `false` indicating that `null` properties should not be included in the serialization.
     *
     * See `Serializable` protocol
     */
    public func includeNonNull() -> Bool {
        return false
    }
}

/**
 * This extension represents the default implementation of the Serializable protocol for all classes that derive from NSObject.
 * In other words, the implementation will serialize/deserialize any object derived from `NSObject`. The serialize method uses
 * Swift's reflection and deserialization uses the setValue method from `NSObject`.
 */
extension Serializable where Self: NSObject {
    public func getParameterTypes() -> [String: NSObject.Type]? {
        return nil
    }

    /**
     * Serializes any Swift object using the `Mirror` class. The `Mirror` class only returns the properties
     * of the current class, not its parents. Therefore, we must loop up the inheritance tree until we reach `NSObject`,
     * which we do not want to serialize.
     *
     * See `Serializable` protocol
     */
    public func serialize() -> NSObject? {
        var mirror: Mirror? = Mirror(reflecting: self)

        var properties = [String: AnyObject]()
        repeat {
            if !mirror!.children.isEmpty {
                for case let (label?, value) in mirror!.children {
                    if let serializableValue = value as? Serializable {
                        if let serializedValue = serializableValue.serialize(),
                            self.includeNonNull() || serializedValue != NSNull() {
                            // If the field name is a Swift reserved word, we must remove the trailing '_' we added before serializing
                            let rawValue = NSString.CompareOptions.backwards.rawValue + NSString.CompareOptions.anchored.rawValue
                            let options = NSString.CompareOptions(rawValue: rawValue)
                            let actualLabel = label.replacingOccurrences(of: "_", with: "", options: options, range: nil)
                            properties[actualLabel] = serializedValue
                        }
                    } else {
                        properties[label] = value as? NSObject
                    }
                }
            }

            mirror = mirror!.superclassMirror
        } while(mirror!.subjectType != NSObject.self)
        return properties as NSObject?
    }

    /**
     * This implementation of deserialize uses the `respondsToSelector` method to set the properties from the serialized
     * key-value pairs. If the object does not respond, then we call a method in class to see if it needs to handle this
     * property in a different way or to determine, finally, that the property does not exist for the object. This process is
     * necessary since Swift and Objective-C always returns `nil` from `respondsToSelector` for properties that are optional and
     * primary, such as `Int?`.
     *
     * See `Serializable` protocol
     */
    public func deserialize(_ object: ObjectType?) throws -> NSObject? {
        guard let properties = object as? [String : AnyObject] else {
            return self
        }

        let parameters = getParameterTypes()

        for (key, _) in properties {
            var object = properties[key]
            if let type = parameters?[key] {
                if let deserializable = type.init() as? Serializable {
                    object = try deserializable.deserialize(properties[key] as? ObjectType)
                }
            }

            if let _ = object as? NSNull {
            } else {
                self.setValue(object, forKey: key)
            }
        }

        return self
    }

    public func valueForUndefinedKey(_ key: String) -> AnyObject? {
        return NSNull()
    }

}

/**
 * This extension overrides the serialize and deserialize method for Optional parameters. This override is necessary
 * so that we properly unwrap the parameter and either return the object or `NSNull`. We must return `NSNull` because the
 * `Dictionary` class does not allow for storing object values of `nil`.
 *
 * See `Serializable` protocol
 */
extension Optional: Serializable {
    public func getParameterTypes() -> [String : NSObject.Type]? {
        return nil
    }

    /**
     * This implementation of `Serializable` unwraps the object and returns `NSNull` if it is `nil`, or the underlying object
     * cast as an `NSObject`.
     *
     * See `Serializable` protocol
     */
    public func serialize() -> NSObject? {
        guard let x = self  else {
            return NSNull()
        }

        // If the object is serializable, serialize it, otherwise attempt to cast as an NSObject
        if let serializable = x as? Serializable {
            return serializable.serialize()
        } else {
            return x as? NSObject
        }
    }

    /**
     * Unwraps the object and returns NSNull if it is nil, or the underlying object cast as an `NSObject`.
     *
     * See `Serializable` protocol
     */
    public func deserialize(_ object: ObjectType?) throws -> NSObject? {
        guard let x = self else {
            return NSNull()
        }

        if let serializable = x as? Serializable {
            return try serializable.deserialize(object)
        } else {
            return x as? NSObject
        }
    }
}

/**
 * This extension defines how arrays are serialized. This method makes it possible to serialize the commands and events which
 * store the header and body in an array.
 */
extension NSMutableArray: Serializable {
    public func serialize() -> NSObject? {
        let array = NSMutableArray()
        for element in self {
            if let serializableElement = element as? Serializable {
                array.add(serializableElement.serialize()!)
            }
        }

        return array
    }
}

/**
 * This extension overrides the deserialize method for `NSNull` so that it returns nil instead of attempting to deserialize the
 * `NSNull` class as an `NSObject`.
 *
 * See `Serializable` protocol
 */
extension NSNull: Serializable {
    /**
     * This implementation just returns nil.
     *
     * See `Serializable` protocol
     */
    public func deserialize(_ object: ObjectType?) throws -> NSObject? {
        return nil
    }
}
