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

// Code generated on 2016-12-16 15:32:01.908796. DO NOT MODIFY

public class Playback {
    public class Subscribe: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "subscribe", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class Unsubscribe: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "unsubscribe", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class GetPlaybackStatus: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "getPlaybackStatus", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class Play: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "play", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class Pause: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "pause", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class SetPlayModes: BaseMessage {
        public class SetPlayModesBody: ControlApi.BaseBody {
            public var playModes: PlayMode?

            public required override init() {
                super.init()
            }

            public convenience init(playModes: PlayMode?) {
                self.init()
                self.playModes = playModes
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["playModes": PlayMode.self]
            }
        }

        public required init() {
            super.init()
            self.body = SetPlayModesBody()
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "setPlayModes", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, body: SetPlayModesBody) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "setPlayModes", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SkipToNextTrack: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "skipToNextTrack", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class SkipToPreviousTrack: BaseMessage {
        public convenience init(groupId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", command: "skipToPreviousTrack", householdId: householdId, targetId: groupId, targetIdType: TargetType.GroupId, cmdId: cmdId)
        }

    }

    public class PlaybackStatus: BaseMessage {
        public class PlaybackStatusBody: ControlApi.BaseBody {
            public var playbackState: String?
            public var queueVersion: String?
            public var itemId: String?
            public var positionMillis: Int?
            public var playModes: PlayMode?
            public var availablePlaybackActions: PlaybackAction?

            public required override init() {
                super.init()
            }

            public convenience init(playbackState: String?, queueVersion: String?, itemId: String?, positionMillis: Int?, playModes: PlayMode?, availablePlaybackActions: PlaybackAction?) {
                self.init()
                self.playbackState = playbackState
                self.queueVersion = queueVersion
                self.itemId = itemId
                self.positionMillis = positionMillis
                self.playModes = playModes
                self.availablePlaybackActions = availablePlaybackActions
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["playModes": PlayMode.self, "availablePlaybackActions": PlaybackAction.self]
            }
        }

        public required init() {
            super.init()
            self.body = PlaybackStatusBody()
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playbackStatus")
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: PlaybackStatusBody) {
            self.init()
            self.header = Header(namespace: "playback:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playbackStatus")
            self.body = body
        }
    }

    public class PlaybackError: BaseMessage {
        public class PlaybackErrorBody: ControlApi.BaseBody {
            public var errorCode: String?
            public var reason: String?
            public var itemId: String?
            public var httpStatus: Int?
            public var httpHeaders: NSDictionary?
            public var queueVersion: String?

            public required override init() {
                super.init()
            }

            public convenience init(errorCode: String?, reason: String?, itemId: String?, httpStatus: Int?, httpHeaders: NSDictionary?, queueVersion: String?) {
                self.init()
                self.errorCode = errorCode
                self.reason = reason
                self.itemId = itemId
                self.httpStatus = httpStatus
                self.httpHeaders = httpHeaders
                self.queueVersion = queueVersion
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "httpStatus" {
                    self.httpStatus = value as? Int
                }
            }
        }

        public required init() {
            super.init()
            self.body = PlaybackErrorBody()
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playback:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playbackError")
        }

        public convenience init(groupId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: PlaybackErrorBody) {
            self.init()
            self.header = Header(namespace: "playback:1", targetId: groupId, targetIdType: TargetType.GroupId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "playbackError")
            self.body = body
        }
    }

}
