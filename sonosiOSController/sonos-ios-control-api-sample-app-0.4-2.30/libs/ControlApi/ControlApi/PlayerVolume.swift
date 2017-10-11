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

// Code generated on 2016-12-16 15:32:01.909756. DO NOT MODIFY

public class PlayerVolume {
    public class Subscribe: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "subscribe", householdId: householdId, cmdId: cmdId)
        }

    }

    public class Unsubscribe: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "unsubscribe", householdId: householdId, cmdId: cmdId)
        }

    }

    public class SetVolume: BaseMessage {
        public class SetVolumeBody: ControlApi.BaseBody {
            public var volume: Int?
            public var muted: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(volume: Int?, muted: Bool?) {
                self.init()
                self.volume = volume
                self.muted = muted
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "volume" {
                    self.volume = value as? Int
                } else if key == "muted" {
                    self.muted = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = SetVolumeBody()
        }

        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setVolume", householdId: householdId, cmdId: cmdId)
        }

        public convenience init(householdId: String?, cmdId: String?, body: SetVolumeBody) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setVolume", householdId: householdId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SetRelativeVolume: BaseMessage {
        public class SetRelativeVolumeBody: ControlApi.BaseBody {
            public var volumeDelta: Int?
            public var muted: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(volumeDelta: Int?, muted: Bool?) {
                self.init()
                self.volumeDelta = volumeDelta
                self.muted = muted
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "volumeDelta" {
                    self.volumeDelta = value as? Int
                } else if key == "muted" {
                    self.muted = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = SetRelativeVolumeBody()
        }

        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setRelativeVolume", householdId: householdId, cmdId: cmdId)
        }

        public convenience init(householdId: String?, cmdId: String?, body: SetRelativeVolumeBody) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setRelativeVolume", householdId: householdId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SetMute: BaseMessage {
        public class SetMuteBody: ControlApi.BaseBody {
            public var muted: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(muted: Bool?) {
                self.init()
                self.muted = muted
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "muted" {
                    self.muted = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = SetMuteBody()
        }

        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setMute", householdId: householdId, cmdId: cmdId)
        }

        public convenience init(householdId: String?, cmdId: String?, body: SetMuteBody) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "setMute", householdId: householdId, cmdId: cmdId)
            self.body = body
        }
    }

    public class GetVolume: BaseMessage {
        public convenience init(householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", command: "getVolume", householdId: householdId, cmdId: cmdId)
        }

    }

    public class PlayerVolume: BaseMessage {
        public class PlayerVolumeBody: ControlApi.BaseBody {
            public var volume: Int?
            public var muted: Bool?
            public var fixed: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(volume: Int?, muted: Bool?, fixed: Bool?) {
                self.init()
                self.volume = volume
                self.muted = muted
                self.fixed = fixed
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "volume" {
                    self.volume = value as? Int
                } else if key == "muted" {
                    self.muted = value as? Bool
                } else if key == "fixed" {
                    self.fixed = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = PlayerVolumeBody()
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playerVolume")
        }

        public convenience init(householdId: String?, cmdId: String?, success: Bool?, response: String?, body: PlayerVolumeBody) {
            self.init()
            self.header = Header(namespace: "playerVolume:1", householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playerVolume")
            self.body = body
        }
    }

}
