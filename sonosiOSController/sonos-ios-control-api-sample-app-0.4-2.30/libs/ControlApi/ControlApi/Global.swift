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

// Code generated on 2016-12-16 15:32:01.908284. DO NOT MODIFY

public class Global {
    public class GroupCoordinatorChanged: BaseMessage {
        public class GroupCoordinatorChangedBody: ControlApi.BaseBody {
            public var groupId: String?
            public var groupStatus: String?
            public var groupName: String?
            public var websocketUrl: String?
            public var playerId: String?

            public required override init() {
                super.init()
            }

            public convenience init(groupId: String?, groupStatus: String?, groupName: String?, websocketUrl: String?, playerId: String?) {
                self.init()
                self.groupId = groupId
                self.groupStatus = groupStatus
                self.groupName = groupName
                self.websocketUrl = websocketUrl
                self.playerId = playerId
            }
        }

        public required init() {
            super.init()
            self.body = GroupCoordinatorChangedBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "global:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "groupCoordinatorChanged")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: GroupCoordinatorChangedBody) {
            self.init()
            self.header = Header(namespace: "global:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "groupCoordinatorChanged")
            self.body = body
        }
    }

}
