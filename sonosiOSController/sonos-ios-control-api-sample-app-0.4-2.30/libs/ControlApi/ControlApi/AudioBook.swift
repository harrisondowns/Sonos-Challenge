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

open class AudioBook: NSObject, Serializable, BaseTrack {
    open var chapterNumber: Int?
    open var author: Artist?
    open var narrator: Artist?
    open var book: Book?
    open var id: UniversalMusicObjectId?
    open var name: String?
    open var type: String? = "audiobook"
    open var imageUrl: String?


    convenience init(id: UniversalMusicObjectId?, name: String?, imageUrl: String?, chapterNumber: Int?, author: Artist?,
        narrator: Artist?, book: Book?) {
        self.init()
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.chapterNumber = chapterNumber
        self.author = author
        self.narrator = narrator
        self.book = book
    }

    open var trackType: String? {
        return self.type
    }

    open func getParameters() -> [String : NSObject.Type]? {
        return ["id": UniversalMusicObjectId.self, "author": Artist.self, "narrator": Artist.self, "book": Book.self]
    }

    /**
     * This implementation checks if the property name is chapterNumber and sets its values if it is.
     *
     * @see Serializable protocol
     */
    open override func setValue( _ value: Any?, forUndefinedKey key: String) {
        if key == "chapterNumber" {
            self.chapterNumber = value as? Int
        }
    }
}
