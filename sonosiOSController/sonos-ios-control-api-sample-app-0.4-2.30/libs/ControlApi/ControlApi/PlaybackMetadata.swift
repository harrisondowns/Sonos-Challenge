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

// Code generated on 2016-12-16 15:32:01.910130. DO NOT MODIFY

public class PlaybackMetadata {
    public class Subscribe: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackMetadata:1", command: "subscribe", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class Unsubscribe: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackMetadata:1", command: "unsubscribe", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class MetadataStatus: BaseMessage {
        public class MetadataStatusBody: ControlApi.BaseBody {
            public var container: Container?
            public var currentItem: QueueItem?
            public var nextItem: QueueItem?

            public required override init() {
                super.init()
            }

            public convenience init(container: Container?, currentItem: QueueItem?, nextItem: QueueItem?) {
                self.init()
                self.container = container
                self.currentItem = currentItem
                self.nextItem = nextItem
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["container": Container.self, "currentItem": QueueItem.self, "nextItem": QueueItem.self]
            }
        }

        public required init() {
            super.init()
            self.body = MetadataStatusBody()
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playbackMetadata:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "metadataStatus")
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: MetadataStatusBody) {
            self.init()
            self.header = Header(namespace: "playbackMetadata:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "metadataStatus")
            self.body = body
        }
    }

}
