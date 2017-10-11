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

import UIKit
import XCTest
@testable import SonosSampleApp
@testable import SonosUtils
@testable import ControlApi

class SonosSampleAppTests: XCTestCase {
    let serializer: JsonSerializer = JsonSerializer()
    let setUpInfo = SonosSampleAppTestsSetUp.self
    let errorPlaybackNoContent = "ERROR_PLAYBACK_NO_CONTENT"
    let id = UniversalMusicObjectId(serviceId: "serviceId", objectId: "objectId", accountId: "accountId")
    let album = Album(name: "The World Ender", artist: nil, id: nil)
    let artist = Artist(name: "Lord Huron", id: nil)
    var player: MockedSonosPlayer = SonosSampleAppTestsSetUp.setupPlayer()
    lazy var track: Track  = {
        return Track(type: "track", name: "The World Ender", mediaUrl: nil, imageUrl: "imageUrl", contentType: nil,
            album: self.album, artist: self.artist, id: self.id, durationMillis: 27000, trackNumber: nil)
    }()
    lazy var queueItem: QueueItem = {
        return QueueItem(id: nil, track: self.track, deleted: nil, policies: nil)
    }()

    override func setUp() {
        super.setUp()
        player = SonosSampleAppTestsSetUp.setupPlayer()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testSubscribed() {
        player.verifySent(try! serializer.toJson(Playback.Subscribe(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
        player.verifySent(try! serializer.toJson(PlaybackMetadata.Subscribe(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
    }

    func testPlay() {
        player.play()
        player.verifySent(try! serializer.toJson(Playback.Play(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
        player.verifyCalled(Callback.onPlayStatusChanged)
        XCTAssertTrue(player.playing)
    }

    func  testPlayNegative() {
        SonosSampleAppTestsSetUp.setupTransportResponses(player, key: Playback.Play(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil), value: Playback.PlaybackError(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil, success: nil, response: nil, body: Playback.PlaybackError.PlaybackErrorBody(errorCode: errorPlaybackNoContent, reason: "No Content Loaded", itemId: nil, httpStatus: nil, httpHeaders: nil, queueVersion: "asdf")))

        player.play()
        player.verifySent(try! serializer.toJson(Playback.Play(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
        player.verifyCalled(Callback.onPlaybackError)
        XCTAssertFalse(player.playing)

    }

    func testPause() {
        player.pause()
        player.verifySent(try! serializer.toJson(Playback.Pause(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
        player.verifyCalled(Callback.onPlayStatusChanged)
        XCTAssertFalse(player.playing)
    }

    func testSkipForward() {
        player.goToNextTrack()
        player.verifySent(try! serializer.toJson(Playback.SkipToNextTrack(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
    }

    func testSkipBackward() {
        player.goToPreviousTrack()
        player.verifySent(try! serializer.toJson(Playback.SkipToPreviousTrack(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId, cmdId: nil)))
    }

    func testMetdataStatusChanged() {
        let metadataStatusBody = PlaybackMetadata.MetadataStatus.MetadataStatusBody(container: nil, currentItem: queueItem,
            nextItem: queueItem)

        player.receiveMessage(try! serializer.toJson(PlaybackMetadata.MetadataStatus(groupId: setUpInfo.groupId, householdId: setUpInfo.householdId,
            cmdId: nil, success: nil, response: nil, body: metadataStatusBody)))

        player.verifyCalled(Callback.onMetadataChanged)
        XCTAssertEqual(track.name!, player.title)
        XCTAssertEqual(track.artist!.name!, player.artist)
        XCTAssertEqual(track.album!.name!, player.album)
        XCTAssertEqual(track.imageUrl!, player.imageUrl)
    }
}
