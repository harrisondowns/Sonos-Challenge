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

open class Podcast: NSObject, Serializable, BaseTrack {
    open var artist: Artist?
    open var show: Show?
    open var id: UniversalMusicObjectId?
    open var name: String?
    open var type: String?
    open var imageUrl: String?

    convenience init(id: UniversalMusicObjectId?, name: String?, imageUrl: String?, artist: Artist?, show: Show?) {
        self.init()
        self.id = id
        self.name = name
        self.type = "podcast"
        self.imageUrl = imageUrl
        self.artist = artist
        self.show = show
    }

    open func getParameters() -> [String : NSObject.Type]? {
        return ["id": UniversalMusicObjectId.self, "artist": Artist.self, "show": Show.self]
    }

    open var trackType: String? {
        return self.type
    }

}
