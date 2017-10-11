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

open class Item: NSObject, Serializable {
    open var id: String?
    open var track: BaseTrack?

    public convenience init(id: String?, track: BaseTrack?) {
        self.init()
        self.id = id

        self.track = track
    }

    /**
     * This implementation must set the track value casted to BaseTrack. The BaseTrackDeserializer takes care of making sure to deserialize
     * the proper type of track, either Track, Podcast or AudioBook.
     *
     * See `Serializable` protocol
     */
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "track" {
            self.track = value as? BaseTrack
        }
    }

    open func getParameterTypes() -> [String: NSObject.Type]? {
        return ["track": BaseTrackDeserializer.self]
    }
}
