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
import XCTest

enum Callback: String {
    // swiftlint:disable type_name
    case onPlayStatusChanged,
    onMetadataChanged,
    onGroupCoordinatorUpdated,
    onGroupCoordinatorMoved,
    onGroupCoordinatorGone,
    onPlaybackError
}

class MockedSonosPlayer: SonosPlayer, PlaybackListener, SonosGlobalListener, GroupListener {
    var onPlayStatusChangedCalled: Bool = false
    var onMetadataChangedCalled: Bool = false
    var onGroupCoordinatorUpdatedCalled: Bool = false
    var onGroupCoordinatorMovedCalled: Bool = false
    var onGroupCoordinatorGoneCalled: Bool = false
    var onPlaybackErrorCalled: Bool = false
    var onGlobalErrorCalled: Bool = false

    var playing: Bool = false

    var title: String = ""
    var artist: String = ""
    var album: String = ""
    var imageUrl: String = ""
    var playerId: String = ""



    override func setup() {
        self.playbackListener = self
        self.sonosGlobalListener = self
        self.groupListener = self
        webSocketHelper = MockedWebSocketHelper()
    }

    func onMetadataChanged(_ title: String?, artist: String?, album: String?, imageUrl: String?) {
        self.onMetadataChangedCalled = true
        if let vTitle = title {
            self.title = vTitle
        }
        if let vArtist = artist {
            self.artist = vArtist
        }
        if let vAlbum = album {
            self.album = vAlbum
        }
        if let vImageUrl = imageUrl {
            self.imageUrl = vImageUrl
        }

    }

    func onPlayStatusChanged(_ playing: Bool) {
        onPlayStatusChangedCalled = true
        self.playing = playing
    }

    func onGroupCoordinatorUpdated(_ groupName: String?) {
        onGroupCoordinatorUpdatedCalled = true
    }

    func onGroupCoordinatorMoved(_ playerId: String?) {
        onGroupCoordinatorMovedCalled = true
        if let vPlayerId = playerId {
            self.playerId = vPlayerId
        }
    }

    func onGroupCoordinatorGone(_ groupName: String?) {
        onGroupCoordinatorGoneCalled = true
        if let vGroupName = groupName {
            self.groupName = vGroupName
        }
    }

    func onConnectionError(_ error: NSError?) {

    }

    func onPlaybackError(_ errorCode: String?, reason: String?) {
        onPlaybackErrorCalled = true
    }

    func onGlobalError(_ errorCode: String?, reason: String?) {
        onGlobalErrorCalled = true
    }

    func verifyCalled(_ callback: Callback) {
        XCTAssertTrue(value(forKey: callback.rawValue + "Called") as! Bool, "Method not called:" + callback.rawValue)
    }

    func verifySent(_ expectedResult: String?) {
        var sent = false
        var message = "Message not sent"
        if let vExpectedResult = expectedResult {
            if let messageArray = TestUtility.convertJsonToArray(vExpectedResult) {
                if let mockedTransport = transport as? MockedWebSocketTransport {
                    sent = mockedTransport.sentMessages.contains(messageArray)
                }
            }
            message += ": " + vExpectedResult
        }
        XCTAssertTrue(sent, message)
    }

    func receiveMessage(_ message: String?) {
        if let vMessage = message, let transport = self.transport as? MockedWebSocketTransport {
            transport.receive(vMessage)
        }
    }
}
