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

// Code generated on 2016-12-16 15:32:01.947536. DO NOT MODIFY

public class Track: NSObject, Serializable {
    public var type: String?
    public var name: String?
    public var mediaUrl: String?
    public var imageUrl: String?
    public var contentType: String?
    public var album: Album?
    public var artist: Artist?
    public var id: UniversalMusicObjectId?
    public var durationMillis: Int?
    public var trackNumber: Int?

    public convenience init(type: String?, name: String?, mediaUrl: String?, imageUrl: String?, contentType: String?, album: Album?, artist: Artist?, id: UniversalMusicObjectId?, durationMillis: Int?, trackNumber: Int?) {
        self.init()
        self.type = type
        self.name = name
        self.mediaUrl = mediaUrl
        self.imageUrl = imageUrl
        self.contentType = contentType
        self.album = album
        self.artist = artist
        self.id = id
        self.durationMillis = durationMillis
        self.trackNumber = trackNumber
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "durationMillis" {
            self.durationMillis = value as? Int
        } else if key == "trackNumber" {
            self.trackNumber = value as? Int
        }
    }

    public func getParameterTypes() -> [String : NSObject.Type]? {
        return ["album": Album.self, "artist": Artist.self, "id": UniversalMusicObjectId.self]
    }
}
