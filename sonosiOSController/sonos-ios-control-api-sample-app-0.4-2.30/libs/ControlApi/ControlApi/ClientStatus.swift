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

// Code generated on 2016-12-16 15:32:01.910506. DO NOT MODIFY

public class ClientStatus {
    public class GetStatus: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "clientStatus:1", command: "getStatus", householdId: householdId, cmdId: cmdId)
        }

    }

    public class Activate: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "clientStatus:1", command: "activate", householdId: householdId, cmdId: cmdId)
        }

    }

    public class Deactivate: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "clientStatus:1", command: "deactivate", householdId: householdId, cmdId: cmdId)
        }

    }

    public class ClientStatus: BaseMessage {
        public class ClientStatusBody: ControlApi.BaseBody {
            public var cloudSubscriptions: CloudSubscriptionStatus?

            public required override init() {
                super.init()
            }

            public convenience init(cloudSubscriptions: CloudSubscriptionStatus?) {
                self.init()
                self.cloudSubscriptions = cloudSubscriptions
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["cloudSubscriptions": CloudSubscriptionStatus.self]
            }
        }

        public required init() {
            super.init()
            self.body = ClientStatusBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "clientStatus:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "clientStatus")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: ClientStatusBody) {
            self.init()
            self.header = Header(namespace: "clientStatus:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "clientStatus")
            self.body = body
        }
    }

    public class CloudSubscriptionStatus: NSObject, Serializable {
        public var active: Bool?
        public var inactiveReason: String?
        public var availabilityDate: String?

        public convenience init(active: Bool?, inactiveReason: String?, availabilityDate: String?) {
            self.init()
            self.active = active
            self.inactiveReason = inactiveReason
            self.availabilityDate = availabilityDate
        }

        public override func setValue(_ value: Any?, forUndefinedKey key: String) {
            if key == "active" {
                self.active = value as? Bool
            }
        }
    }
}
