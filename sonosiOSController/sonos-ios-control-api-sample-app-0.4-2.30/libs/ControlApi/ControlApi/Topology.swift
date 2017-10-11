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

// Code generated on 2016-12-16 15:32:01.908488. DO NOT MODIFY

public class Topology {
    public class Subscribe: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "topology:1", command: "subscribe", householdId: householdId, cmdId: cmdId)
        }

    }

    public class Unsubscribe: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "topology:1", command: "unsubscribe", householdId: householdId, cmdId: cmdId)
        }

    }

    public class GetTopologyStatus: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "topology:1", command: "getTopologyStatus", householdId: householdId, cmdId: cmdId)
        }

    }

    public class TopologyStatus: BaseMessage {
        public class TopologyStatusBody: ControlApi.BaseBody {
            public var householdLocationId: String?
            public var sonosId: String?
            public var devices: TopologyDevice?

            public required override init() {
                super.init()
            }

            public convenience init(householdLocationId: String?, sonosId: String?, devices: TopologyDevice?) {
                self.init()
                self.householdLocationId = householdLocationId
                self.sonosId = sonosId
                self.devices = devices
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["devices": TopologyDevice.self]
            }
        }

        public required init() {
            super.init()
            self.body = TopologyStatusBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "topology:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "topologyStatus")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: TopologyStatusBody) {
            self.init()
            self.header = Header(namespace: "topology:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "topologyStatus")
            self.body = body
        }
    }

    public class CloudRegistrationStatus: BaseMessage {
        public class CloudRegistrationStatusBody: ControlApi.BaseBody {
            public var sonosId: String?
            public var playerId: String?
            public var groupId: String?
            public var sessionId: String?
            public var householdLocationId: String?
            public var roomName: String?
            public var serial: String?
            public var model: String?
            public var ipAddr: String?
            public var port: Int?
            public var isCoordinator: Bool?
            public var isVisible: Bool?
            public var isSatellite: Bool?
            public var isSecure: Bool?
            public var hwVersion: String?
            public var swVersion: String?

            public required override init() {
                super.init()
            }

            public convenience init(sonosId: String?, playerId: String?, groupId: String?, sessionId: String?, householdLocationId: String?, roomName: String?, serial: String?, model: String?, ipAddr: String?, port: Int?, isCoordinator: Bool?, isVisible: Bool?, isSatellite: Bool?, isSecure: Bool?, hwVersion: String?, swVersion: String?) {
                self.init()
                self.sonosId = sonosId
                self.playerId = playerId
                self.groupId = groupId
                self.sessionId = sessionId
                self.householdLocationId = householdLocationId
                self.roomName = roomName
                self.serial = serial
                self.model = model
                self.ipAddr = ipAddr
                self.port = port
                self.isCoordinator = isCoordinator
                self.isVisible = isVisible
                self.isSatellite = isSatellite
                self.isSecure = isSecure
                self.hwVersion = hwVersion
                self.swVersion = swVersion
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "port" {
                    self.port = value as? Int
                } else if key == "isCoordinator" {
                    self.isCoordinator = value as? Bool
                } else if key == "isVisible" {
                    self.isVisible = value as? Bool
                } else if key == "isSatellite" {
                    self.isSatellite = value as? Bool
                } else if key == "isSecure" {
                    self.isSecure = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = CloudRegistrationStatusBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "topology:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "cloudRegistrationStatus")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: CloudRegistrationStatusBody) {
            self.init()
            self.header = Header(namespace: "topology:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "cloudRegistrationStatus")
            self.body = body
        }
    }

    public class TopologyDevice: NSObject, Serializable {
        public var playerId: String?
        public var groupId: String?
        public var ipAddr: String?
        public var hwVersion: String?
        public var swVersion: String?
        public var isCoordinator: Bool?
        public var isVisible: Bool?
        public var isSatellite: Bool?

        public convenience init(playerId: String?, groupId: String?, ipAddr: String?, hwVersion: String?, swVersion: String?, isCoordinator: Bool?, isVisible: Bool?, isSatellite: Bool?) {
            self.init()
            self.playerId = playerId
            self.groupId = groupId
            self.ipAddr = ipAddr
            self.hwVersion = hwVersion
            self.swVersion = swVersion
            self.isCoordinator = isCoordinator
            self.isVisible = isVisible
            self.isSatellite = isSatellite
        }

        public override func setValue(_ value: Any?, forUndefinedKey key: String) {
            if key == "isCoordinator" {
                self.isCoordinator = value as? Bool
            } else if key == "isVisible" {
                self.isVisible = value as? Bool
            } else if key == "isSatellite" {
                self.isSatellite = value as? Bool
            }
        }
    }
}
