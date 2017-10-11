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

import Foundation
@testable import SonosSampleApp
@testable import SonosUtils
@testable import ControlApi

class SonosSampleAppTestsSetUp {
    static let serializer: JsonSerializer = JsonSerializer()
    static let address = "http://test.com"
    static let groupId = "ABCDEFG"
    static let sessionId = "ABCDEFG:1"
    static let householdId = "xyz123"
    static let groupName = "test:123"
    static let playerId = "12345"
    static let groupStatusGone = "GROUP_STATUS_GONE"
    static let groupStatusMoved = "GROUP_STATUS_MOVED"
    static let groupStatusUpdated = "GROUP_STATUS_UPDATED"

    static func setupPlayer() -> MockedSonosPlayer {
        let player = MockedSonosPlayer(address: address, groupId: groupId, householdId: householdId,
            groupName: groupName)

        player.webSocketHelper = MockedWebSocketHelper()
        player.webSocketHelper?.connect(address)
        if let transport = player.transport as? MockedWebSocketTransport {
            transport.responses = [
                TestUtility.convertSerializableToArray(Playback.Play(groupId: groupId, householdId: householdId, cmdId: nil))!:
                    try! serializer.toJson(Playback.PlaybackStatus(groupId: groupId, householdId: householdId, cmdId: nil,
                        success: nil, response: nil, body: Playback.PlaybackStatus.PlaybackStatusBody(
                            playbackState: "PLAYBACK_STATE_PLAYING", queueVersion: nil, itemId: nil, positionMillis: 0, playModes: nil, availablePlaybackActions: nil))),
                TestUtility.convertSerializableToArray(Playback.Pause(groupId: groupId, householdId: householdId, cmdId: nil))!:
                    try! serializer.toJson(Playback.PlaybackStatus(groupId: groupId, householdId: householdId, cmdId: nil,
                        success: nil, response: nil,
                        body: Playback.PlaybackStatus.PlaybackStatusBody(playbackState: "PLAYBACK_STATE_PAUSED",
                                                                         queueVersion: nil, itemId: nil, positionMillis: 0, playModes: nil, availablePlaybackActions: nil))),
            ]
        }
        return player
    }

    static func setupTransportResponses(_ player: MockedSonosPlayer, key: BaseMessage, value: BaseMessage) {
        if let transport = player.transport as? MockedWebSocketTransport {
            if let oldValue = transport.responses?.updateValue(try! serializer.toJson(value), forKey: TestUtility.convertSerializableToArray(key)!) {
                print ("The old value: \(oldValue)")
            }
        }
    }
}
