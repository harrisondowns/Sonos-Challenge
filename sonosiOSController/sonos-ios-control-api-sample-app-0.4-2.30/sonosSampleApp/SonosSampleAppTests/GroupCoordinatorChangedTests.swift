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

class GroupCoordinatorChangedTests: XCTestCase {
    let serializer: JsonSerializer = JsonSerializer()
    let groupStatusGone = "GROUP_STATUS_GONE"
    let groupStatusMoved = "GROUP_STATUS_MOVED"
    let groupStatusUpdated = "GROUP_STATUS_UPDATED"
    let setUpInfo = SonosSampleAppTestsSetUp.self
    var player: MockedSonosPlayer?
    override func setUp() {
        super.setUp()
        player = SonosSampleAppTestsSetUp.setupPlayer()
    }

    override func tearDown() {
        player = nil
        super.tearDown()
    }

    func testGroupCoordinatorUpdated() {
        let groupCoordinatorUpdatedBody = Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody(groupId:
            setUpInfo.groupId, groupStatus: groupStatusUpdated, groupName: setUpInfo.groupName, websocketUrl: nil, playerId: nil)
        player!.receiveMessage(try! serializer.toJson(Global.GroupCoordinatorChanged(householdId: setUpInfo.householdId,
            cmdId: nil, success: true, response: nil, body: groupCoordinatorUpdatedBody)))
        player!.verifyCalled(Callback.onGroupCoordinatorUpdated)
        XCTAssertEqual(setUpInfo.groupName, player?.groupName, "groupName should be updated when a " +
            "groupCoordinatorUpdated event is received")
    }

    func testGroupCoordinatorMoved() {
        let groupCoordinatorMovedBody = Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody(groupId:
            setUpInfo.groupId, groupStatus: groupStatusMoved, groupName: setUpInfo.groupName, websocketUrl: SonosSampleAppTestsSetUp.address, playerId: setUpInfo.playerId)
        player!.receiveMessage(try! serializer.toJson(Global.GroupCoordinatorChanged(householdId: setUpInfo.householdId,
            cmdId: nil, success: true, response: nil, body: groupCoordinatorMovedBody)))
        player!.verifyCalled(Callback.onGroupCoordinatorMoved)
        XCTAssertEqual(setUpInfo.groupName, player?.groupName, "groupName should be updated when a " +
            "groupCoordinatorMoved event is received")
        XCTAssertEqual(setUpInfo.address, player?.webSocketAddress, "WebsocketUrl should be updated when a " +
            "groupCoordinatorMoved event is received")
        XCTAssertEqual(setUpInfo.playerId, player?.playerId, "PlayerId should be updated when a " +
            "groupCoordinatorMoved event is received")
    }

    func testGroupCoordinatorGone() {
        let groupCoordinatorGoneBody = Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody(groupId:
            setUpInfo.groupId, groupStatus: groupStatusGone, groupName: setUpInfo.groupName, websocketUrl: nil, playerId: nil)
        player!.receiveMessage(try! serializer.toJson(Global.GroupCoordinatorChanged(householdId: setUpInfo.householdId,
            cmdId: nil, success: true, response: nil, body: groupCoordinatorGoneBody)))
        player!.verifyCalled(Callback.onGroupCoordinatorGone)
        XCTAssertEqual(setUpInfo.groupName, player?.groupName, "groupName intercepted in the groupCooridnatorGone " +
            "call should match that passed in to the websocket")
    }
}
