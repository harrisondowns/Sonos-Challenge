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

// Code generated on 2016-12-16 15:32:01.949046. DO NOT MODIFY

public class TrackMetadata: NSObject, Serializable {
    public var itemId: String?
    public var title: String?
    public var artist: String?
    public var album: String?
    public var albumArtist: String?
    public var imageUrl: String?
    public var duration: Int?
    public var trackUrl: String?
    public var contentType: String?

    public convenience init(itemId: String?, title: String?, artist: String?, album: String?, albumArtist: String?, imageUrl: String?, duration: Int?, trackUrl: String?, contentType: String?) {
        self.init()
        self.itemId = itemId
        self.title = title
        self.artist = artist
        self.album = album
        self.albumArtist = albumArtist
        self.imageUrl = imageUrl
        self.duration = duration
        self.trackUrl = trackUrl
        self.contentType = contentType
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "duration" {
            self.duration = value as? Int
        }
    }
}
