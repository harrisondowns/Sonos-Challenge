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

class SonosGroupDiscoveryTests: XCTestCase {

    let sonosGroupDiscoveryListener: MockedSonosGroupDiscoveryListener = MockedSonosGroupDiscoveryListener()

    var sonosGroupDiscovery: MockedSonosGroupDiscovery = MockedSonosGroupDiscovery()
    static let uuid = "XYZ_000UVW123RST456"
    static let uuid2 = "XYZ_111UVW123RST456"

    static let gc = "1"
    static let gname = "Kitchen"
    static let gname2 = "Rest Room"
    static let gid = "ABC_987DEF012:0"
    static let gid2 = "ABC_987DEF012:1"

    static var groups: [String : [String : String]]?

    static var mSearchResponse =
        "HTTP/1.1 200 OK\r\n" +
        "CACHE-CONTROL: max-age = 3600\r\n" +
        "EXT:\r\n" + "LOCATION: http://0.0.0.0:1400/xml/group_description.xml\r\n" +
        "SERVER: Linux UPnP/1.1 Sonos/00.0-00000-test (ABC1)\r\n" +
        "ST: urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "USN: uuid:\(uuid)::urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "BOOTID.UPNP.ORG: 00\r\n" + "CONFIGID.UPNP.ORG: 0\r\n" +
        "GROUPINFO.SMARTSPEAKER.AUDIO: gc=\(gc); gid=\(gid); gname=\(gname)\r\n" +
        "WEBSOCK.SMARTSPEAKER.AUDIO: wss://0.0.0.0:1443/websocket/api/\r\n" +
        "HOUSEHOLD.SMARTSPEAKER.AUDIO: Sonos_1234DDD5678TTT9012BB345\r\n"

    static var ssdpAliveNotification =
        "NOTIFY * HTTP/1.1\r\n" +
        "HOST: 239.255.255.250:1900\r\n" +
        "CACHE-CONTROL: max-age = 3600\r\n" +
        "LOCATION: http://0.0.0.0:1400/xml/group_description.xml\r\n" +
        "SERVER: Linux UPnP/1.1 Sonos/00.0-00000-test (ABC1)\r\n" +
        "NT: urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "NTS: ssdp:alive\r\n" +
        "USN: uuid:\(uuid2):: urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "BOOTID.UPNP.ORG:\r\n" +
        "CONFIGID.UPNP.ORG:\r\n" +
        "GROUPINFO.SMARTSPEAKER.AUDIO: gc=\(gc); gid=\(gid2); gname=\(gname2)\r\n" +
        "WEBSOCK.SMARTSPEAKER.AUDIO: wss://0.0.0.0:1443/websocket/api/\r\n" +
        "HOUSEHOLD.SMARTSPEAKER.AUDIO: Sonos_1234DDD5678TTT9012BB345\r\n"

    static var ssdpByebyeNotification =
        "NOTIFY * HTTP/1.1\r\n" +
        "HOST: 239.255.255.250:1900\r\n" +
        "SERVER: OS/version UPnP/1.1 product/version\r\n" +
        "NT: urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "NTS: ssdp:byebye\r\n" +
        "USN: uuid:XYZ_000UVW123RST456::urn:smartspeaker-audio:service:SpeakerGroup:1\r\n" +
        "BOOTID.UPNP.ORG:\r\n" +
        "CONFIGID.UPNP.ORG:\r\n"

    override func setUp() {
        super.setUp()
        sonosGroupDiscovery = MockedSonosGroupDiscovery(mockedGroupDiscoveryListener: sonosGroupDiscoveryListener)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMsearchRequestAndResponseAndByebyeNotification() {
        self.sonosGroupDiscovery.start()

        if let groups = SonosGroupDiscoveryTests.groups {
            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid]!["gname"], SonosGroupDiscoveryTests.gname,
                           "the expected gname should be the same as the gname received")

            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid]!["gid"], SonosGroupDiscoveryTests.gid,
                           "the expected gid should be the same as the gid received")

            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid]!["gc"], SonosGroupDiscoveryTests.gc,
                           "the expected gc should be the same as the gc received")
        } else {
            XCTFail("The test fails to discover any groups from injected M-Search response")
        }
        self.sonosGroupDiscovery.receiveNotification(SonosGroupDiscoveryTests.ssdpByebyeNotification)
        XCTAssertEqual(SonosGroupDiscoveryTests.groups?.count, 0, 
            "The previous discovered group should be cleared upon receiving a SSDP Byebye notification")

    }

    func testAliveNotification() {

        self.sonosGroupDiscovery.start()

        self.sonosGroupDiscovery.receiveNotification(SonosGroupDiscoveryTests.ssdpAliveNotification)

        if let groups = SonosGroupDiscoveryTests.groups {
            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid2]!["gname"], SonosGroupDiscoveryTests.gname2,
                           "the expected gname should be the same as the gname received")

            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid2]!["gid"], SonosGroupDiscoveryTests.gid2,
                           "the expected gid should be the same as the gid received")

            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid2]!["gc"], SonosGroupDiscoveryTests.gc,
                           "the expected gc should be the same as the gc received")

            XCTAssertEqual(groups[SonosGroupDiscoveryTests.uuid2]!["NTS"], "ssdp:alive",
                           "the expected NTS value should be the same as the the NTS value received")
        } else {
            XCTFail("The test fails to discover any groups from injected SSDP Alive Notification")
        }

    }

    static func setGroupsIntercepted(_ groups: [String : [String : String]]) {
        SonosGroupDiscoveryTests.groups = groups
    }
}
