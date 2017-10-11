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

// Code generated on 2016-12-16 15:32:01.909085. DO NOT MODIFY

public class PlaybackSession {
    public class Subscribe: BaseMessage {
        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "subscribe", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

    }

    public class Unsubscribe: BaseMessage {
        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "unsubscribe", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

    }

    public class JoinOrCreateSession: BaseMessage {
        public class JoinOrCreateSessionBody: ControlApi.BaseBody {
            public var appId: String?
            public var appContext: String?
            public var accountId: String?
            public var customData: String?

            public required override init() {
                super.init()
            }

            public convenience init(appId: String?, appContext: String?, accountId: String?, customData: String?) {
                self.init()
                self.appId = appId
                self.appContext = appContext
                self.accountId = accountId
                self.customData = customData
            }
        }

        public required init() {
            super.init()
            self.body = JoinOrCreateSessionBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "joinOrCreateSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: JoinOrCreateSessionBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "joinOrCreateSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class JoinSession: BaseMessage {
        public class JoinSessionBody: ControlApi.BaseBody {
            public var appId: String?
            public var appContext: String?

            public required override init() {
                super.init()
            }

            public convenience init(appId: String?, appContext: String?) {
                self.init()
                self.appId = appId
                self.appContext = appContext
            }
        }

        public required init() {
            super.init()
            self.body = JoinSessionBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "joinSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: JoinSessionBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "joinSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class RejoinSession: BaseMessage {
        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "rejoinSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

    }

    public class CreateSession: BaseMessage {
        public class CreateSessionBody: ControlApi.BaseBody {
            public var appId: String?
            public var appContext: String?
            public var accountId: String?
            public var customData: String?

            public required override init() {
                super.init()
            }

            public convenience init(appId: String?, appContext: String?, accountId: String?, customData: String?) {
                self.init()
                self.appId = appId
                self.appContext = appContext
                self.accountId = accountId
                self.customData = customData
            }
        }

        public required init() {
            super.init()
            self.body = CreateSessionBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "createSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: CreateSessionBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "createSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class Suspend: BaseMessage {
        public class SuspendBody: ControlApi.BaseBody {
            public var queueVersion: String?

            public required override init() {
                super.init()
            }

            public convenience init(queueVersion: String?) {
                self.init()
                self.queueVersion = queueVersion
            }
        }

        public required init() {
            super.init()
            self.body = SuspendBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "suspend", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: SuspendBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "suspend", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class LeaveSession: BaseMessage {
        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "leaveSession", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

    }

    public class LoadCloudQueue: BaseMessage {
        public class LoadCloudQueueBody: ControlApi.BaseBody {
            public var queueBaseUrl: String?
            public var httpAuthorization: String?
            public var itemId: String?
            public var queueVersion: String?
            public var positionMillis: Int?
            public var playOnCompletion: Bool?
            public var trackMetadata: Track?

            public required override init() {
                super.init()
            }

            public convenience init(queueBaseUrl: String?, httpAuthorization: String?, itemId: String?, queueVersion: String?, positionMillis: Int?, playOnCompletion: Bool?, trackMetadata: Track?) {
                self.init()
                self.queueBaseUrl = queueBaseUrl
                self.httpAuthorization = httpAuthorization
                self.itemId = itemId
                self.queueVersion = queueVersion
                self.positionMillis = positionMillis
                self.playOnCompletion = playOnCompletion
                self.trackMetadata = trackMetadata
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                } else if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["trackMetadata": Track.self]
            }
        }

        public required init() {
            super.init()
            self.body = LoadCloudQueueBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadCloudQueue", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: LoadCloudQueueBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadCloudQueue", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class LoadStreamUrl: BaseMessage {
        public class LoadStreamUrlBody: ControlApi.BaseBody {
            public var streamUrl: String?
            public var playOnCompletion: Bool?
            public var stationMetadata: Container?

            public required override init() {
                super.init()
            }

            public convenience init(streamUrl: String?, playOnCompletion: Bool?, stationMetadata: Container?) {
                self.init()
                self.streamUrl = streamUrl
                self.playOnCompletion = playOnCompletion
                self.stationMetadata = stationMetadata
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["stationMetadata": Container.self]
            }
        }

        public required init() {
            super.init()
            self.body = LoadStreamUrlBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadStreamUrl", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: LoadStreamUrlBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadStreamUrl", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class LoadCloudQueueWithWindow: BaseMessage {
        public class LoadCloudQueueWithWindowBody: ControlApi.BaseBody {
            public var queueBaseUrl: String?
            public var itemId: String?
            public var window: QueueItemWindow?
            public var httpAuthorization: String?
            public var accountId: String?
            public var positionMillis: Int?
            public var playOnCompletion: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(queueBaseUrl: String?, itemId: String?, window: QueueItemWindow?, httpAuthorization: String?, accountId: String?, positionMillis: Int?, playOnCompletion: Bool?) {
                self.init()
                self.queueBaseUrl = queueBaseUrl
                self.itemId = itemId
                self.window = window
                self.httpAuthorization = httpAuthorization
                self.accountId = accountId
                self.positionMillis = positionMillis
                self.playOnCompletion = playOnCompletion
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                } else if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["window": QueueItemWindow.self]
            }
        }

        public required init() {
            super.init()
            self.body = LoadCloudQueueWithWindowBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadCloudQueueWithWindow", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: LoadCloudQueueWithWindowBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadCloudQueueWithWindow", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class RefreshCloudQueue: BaseMessage {
        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "refreshCloudQueue", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

    }

    public class LoadProgrammedRadio: BaseMessage {
        public class LoadProgrammedRadioBody: ControlApi.BaseBody {
            public var stationId: UniversalMusicObjectId?
            public var playOnCompletion: Bool?
            public var stationMetadata: Container?

            public required override init() {
                super.init()
            }

            public convenience init(stationId: UniversalMusicObjectId?, playOnCompletion: Bool?, stationMetadata: Container?) {
                self.init()
                self.stationId = stationId
                self.playOnCompletion = playOnCompletion
                self.stationMetadata = stationMetadata
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["stationId": UniversalMusicObjectId.self, "stationMetadata": Container.self]
            }
        }

        public required init() {
            super.init()
            self.body = LoadProgrammedRadioBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadProgrammedRadio", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: LoadProgrammedRadioBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "loadProgrammedRadio", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SkipToItem: BaseMessage {
        public class SkipToItemBody: ControlApi.BaseBody {
            public var itemId: String?
            public var queueVersion: String?
            public var positionMillis: Int?
            public var playOnCompletion: Bool?
            public var trackMetadata: Track?

            public required override init() {
                super.init()
            }

            public convenience init(itemId: String?, queueVersion: String?, positionMillis: Int?, playOnCompletion: Bool?, trackMetadata: Track?) {
                self.init()
                self.itemId = itemId
                self.queueVersion = queueVersion
                self.positionMillis = positionMillis
                self.playOnCompletion = playOnCompletion
                self.trackMetadata = trackMetadata
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                } else if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["trackMetadata": Track.self]
            }
        }

        public required init() {
            super.init()
            self.body = SkipToItemBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "skipToItem", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: SkipToItemBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "skipToItem", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SkipToItemWithWindow: BaseMessage {
        public class SkipToItemWithWindowBody: ControlApi.BaseBody {
            public var itemId: String?
            public var window: QueueItemWindow?
            public var positionMillis: Int?
            public var playOnCompletion: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(itemId: String?, window: QueueItemWindow?, positionMillis: Int?, playOnCompletion: Bool?) {
                self.init()
                self.itemId = itemId
                self.window = window
                self.positionMillis = positionMillis
                self.playOnCompletion = playOnCompletion
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                } else if key == "playOnCompletion" {
                    self.playOnCompletion = value as? Bool
                }
            }

            public override func getParameterTypes() -> [String : NSObject.Type]? {
                return ["window": QueueItemWindow.self]
            }
        }

        public required init() {
            super.init()
            self.body = SkipToItemWithWindowBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "skipToItemWithWindow", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: SkipToItemWithWindowBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "skipToItemWithWindow", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class Seek: BaseMessage {
        public class SeekBody: ControlApi.BaseBody {
            public var itemId: String?
            public var positionMillis: Int?

            public required override init() {
                super.init()
            }

            public convenience init(itemId: String?, positionMillis: Int?) {
                self.init()
                self.itemId = itemId
                self.positionMillis = positionMillis
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "positionMillis" {
                    self.positionMillis = value as? Int
                }
            }
        }

        public required init() {
            super.init()
            self.body = SeekBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "seek", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, body: SeekBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", command: "seek", householdId: householdId, targetId: sessionId, targetIdType: TargetType.SessionId, cmdId: cmdId)
            self.body = body
        }
    }

    public class SessionStatus: BaseMessage {
        public class SessionStatusBody: ControlApi.BaseBody {
            public var sessionState: String?
            public var sessionId: String?
            public var sessionCreated: Bool?
            public var customData: String?

            public required override init() {
                super.init()
            }

            public convenience init(sessionState: String?, sessionId: String?, sessionCreated: Bool?, customData: String?) {
                self.init()
                self.sessionState = sessionState
                self.sessionId = sessionId
                self.sessionCreated = sessionCreated
                self.customData = customData
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "sessionCreated" {
                    self.sessionCreated = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = SessionStatusBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionStatus")
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: SessionStatusBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionStatus")
            self.body = body
        }
    }

    public class SessionError: BaseMessage {
        public class SessionErrorBody: ControlApi.BaseBody {
            public var errorCode: String?
            public var reason: String?

            public required override init() {
                super.init()
            }

            public convenience init(errorCode: String?, reason: String?) {
                self.init()
                self.errorCode = errorCode
                self.reason = reason
            }
        }

        public required init() {
            super.init()
            self.body = SessionErrorBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionError")
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: SessionErrorBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionError")
            self.body = body
        }
    }

    public class SessionInfo: BaseMessage {
        public class SessionInfoBody: ControlApi.BaseBody {
            public var suspended: Bool?

            public required override init() {
                super.init()
            }

            public convenience init(suspended: Bool?) {
                self.init()
                self.suspended = suspended
            }

            public override func setValue(_ value: Any?, forUndefinedKey key: String) {
                if key == "suspended" {
                    self.suspended = value as? Bool
                }
            }
        }

        public required init() {
            super.init()
            self.body = SessionInfoBody()
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionInfo")
        }

        public convenience init(sessionId: String?, householdId: String?, cmdId: String?, success: Bool?, response: String?, body: SessionInfoBody) {
            self.init()
            self.header = Header(namespace: "playbackSession:1", targetId: sessionId, targetIdType: TargetType.SessionId, householdId: householdId, cmdId: cmdId, success: success, response: response, type: "sessionInfo")
            self.body = body
        }
    }

}
