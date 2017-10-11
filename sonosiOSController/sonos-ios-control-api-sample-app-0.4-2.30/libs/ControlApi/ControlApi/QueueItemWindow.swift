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

// Code generated on 2016-12-16 15:32:01.948412. DO NOT MODIFY

public class QueueItemWindow: NSObject, Serializable {
    public var includesBeginningOfQueue: Bool?
    public var includesEndOfQueue: Bool?
    public var contextVersion: String?
    public var queueVersion: String?
    public var items: QueueItem?

    public convenience init(includesBeginningOfQueue: Bool?, includesEndOfQueue: Bool?, contextVersion: String?, queueVersion: String?, items: QueueItem?) {
        self.init()
        self.includesBeginningOfQueue = includesBeginningOfQueue
        self.includesEndOfQueue = includesEndOfQueue
        self.contextVersion = contextVersion
        self.queueVersion = queueVersion
        self.items = items
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "includesBeginningOfQueue" {
            self.includesBeginningOfQueue = value as? Bool
        } else if key == "includesEndOfQueue" {
            self.includesEndOfQueue = value as? Bool
        }
    }

    public func getParameterTypes() -> [String : NSObject.Type]? {
        return ["items": QueueItem.self]
    }
}
