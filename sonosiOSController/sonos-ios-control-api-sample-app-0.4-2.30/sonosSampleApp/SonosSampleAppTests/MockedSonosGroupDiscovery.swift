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
import XCTest
@testable import SonosSampleApp
@testable import SonosUtils

class MockedSonosGroupDiscovery: SonosGroupDiscovery {
    let address = "test.com".data(using: String.Encoding.utf8, allowLossyConversion: false)
    let filterContext = "filterContext"

    convenience init(mockedGroupDiscoveryListener: MockedSonosGroupDiscoveryListener) {
        self.init()
        self.listener = mockedGroupDiscoveryListener
    }

    override func sendMSearchRequest(_ socket: GCDAsyncUdpSocket, withData data: Data?, toHost host: String?,
        withCounter counter: inout Int, andWait wait: Int64) {
            let dataStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        XCTAssertEqual(SonosGroupDiscovery.discoveryMessage, (dataStr as! String),
                       "The expected mSearchMessage should be equal to the those sent by UDP sockets")
        let responseData = SonosGroupDiscoveryTests.mSearchResponse.data(using: String.Encoding.utf8,
                                                                                      allowLossyConversion: false)
        self.udpSocket(self.multicastListeningSocket!, didReceive: responseData!, fromAddress: address!,
                       withFilterContext: filterContext)
    }

    func receiveNotification(_ notification: String) {
        let notificationData = notification.data(using: String.Encoding.utf8, allowLossyConversion: false)
        self.udpSocket(self.multicastListeningSocket!, didReceive: notificationData!, fromAddress: address!,
                       withFilterContext: filterContext)
    }

    override func start() -> Bool {
        self.startMulticastListener()
        self.sendMsearchRequests()
        return true
    }
}
