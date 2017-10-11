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

// Code generated on 2016-12-16 15:32:01.947141. DO NOT MODIFY

public class Container: NSObject, Serializable {
    public var name: String?
    public var type: String?
    public var id: UniversalMusicObjectId?
    public var service: Service?
    public var imageUrl: String?

    public convenience init(name: String?, type: String?, id: UniversalMusicObjectId?, service: Service?, imageUrl: String?) {
        self.init()
        self.name = name
        self.type = type
        self.id = id
        self.service = service
        self.imageUrl = imageUrl
    }

    public func getParameterTypes() -> [String : NSObject.Type]? {
        return ["id": UniversalMusicObjectId.self, "service": Service.self]
    }
}
