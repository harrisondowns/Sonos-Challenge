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

// Code generated on 2016-12-16 15:32:01.910285. DO NOT MODIFY

public class MusicServiceAccounts {
    public class Match: BaseMessage {
        public class MatchBody: ControlApi.BaseBody {
            public var userIdHashCode: String?
            public var nickname: String?
            public var service: Service?
            public var linkCode: String?

            public required override init() {
                super.init()
            }

            public convenience init(userIdHashCode: String?, nickname: String?, service: Service?, linkCode: String?) {
                self.init()
                self.userIdHashCode = userIdHashCode
                self.nickname = nickname
                self.service = service
                self.linkCode = linkCode
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["service": Service.self]
            }
        }

        public required init() {
            super.init()
            self.body = MatchBody()
        }

        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "musicServiceAccounts:1", command: "match", householdId: householdId, cmdId: cmdId)
        }

        public convenience init(householdId: String?, cmdId: String?, body: MatchBody) {
            self.init()
            self.header = Header(namespace: "musicServiceAccounts:1", command: "match", householdId: householdId, cmdId: cmdId)
            self.body = body
        }
    }

    public class MusicServiceAccount: BaseMessage {
        public class MusicServiceAccountBody: ControlApi.BaseBody {
            public var userIdHashCode: String?
            public var nickname: String?
            public var id: String?
            public var isGuest: Bool?
            public var service: Service?

            public required override init() {
                super.init()
            }

            public convenience init(userIdHashCode: String?, nickname: String?, id: String?, isGuest: Bool?, service: Service?) {
                self.init()
                self.userIdHashCode = userIdHashCode
                self.nickname = nickname
                self.id = id
                self.isGuest = isGuest
                self.service = service
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "isGuest" {
                    self.isGuest = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["service": Service.self]
            }
        }

        public required init() {
            super.init()
            self.body = MusicServiceAccountBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "musicServiceAccounts:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "musicServiceAccount")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: MusicServiceAccountBody) {
            self.init()
            self.header = Header(namespace: "musicServiceAccounts:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "musicServiceAccount")
            self.body = body
        }
    }

}
