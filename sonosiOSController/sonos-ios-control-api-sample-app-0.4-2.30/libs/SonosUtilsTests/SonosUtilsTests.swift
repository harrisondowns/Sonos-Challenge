//
//  SonosUtilsTests.swift
//  SonosUtilsTests
//
//  Created by Allan Knight on 12/18/15.
//  Copyright © 2015 Sonos, Inc. All rights reserved.
//

import XCTest
import SonosUtils

class SonosUtilsTests: XCTestCase {

    class MockWebSocket: Socket {
        init() {
        }

        var connected: Bool = false

        var onConnect: ((Transport) -> Void)?
        var onDisconnect: ((NSError?) -> Void)?
        var onString: ((String) -> Void)?
        var onData: ((Data) -> Void)?

        var error: NSError?

        fileprivate var stringReceived: String?
        fileprivate var dataReceived: Data?

        func connect(_ address: String) {
            NSLog("Connect called!")

            if let _ = self.error {
                connected = false
                onDisconnect?(error)
            } else {
                connected = true
                onConnect?(WebSocketTransport(socket: self))
            }
        }

        func getStringReceived() -> (String?) {
            return stringReceived
        }

        func getDataReceived() -> (Data?) {
            return dataReceived
        }

        func receiveData(_ data: Data) {
            onData?(data)
        }

        func disconnect() {
            connected = false
            onDisconnect?(nil)
        }

        func sendString(_ str: String) {
            stringReceived = str
        }

        func sendData(_ data: Data) {
            dataReceived = data
        }

        func isConnected() -> (Bool) {
            return connected
        }
    }

    var mockSocket: MockWebSocket?
    var helper: WebSocketHelper?
    var calledOnConnected = false
    var calledOnDisconnected = false
    var calledOnReceived = false

    override func setUp() {
        super.setUp()

        mockSocket = MockWebSocket()
        helper = WebSocketHelper(socket: mockSocket!)

        calledOnConnected = false
        calledOnDisconnected = false
        calledOnReceived = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWebSocketHelperSuccessfulConnect() {
        helper!.onConnected = { transport in
            XCTAssertNotNil(transport)
            XCTAssert(transport.isConnected())
            self.calledOnConnected = true
        }

        helper!.onDisconnected = { error in
            XCTFail("onDisconnected called instead of onConnect!")
        }

        helper!.connect("ws://localhost:8080")
        XCTAssert(calledOnConnected)
    }

    func testWebSocketHelperUnsuccessfulConnect() {

        mockSocket!.error = NSError(domain: "MockWebSocket", code: -1, userInfo: nil)
        helper!.onConnected = { transport in
            XCTFail("onConnected called instead of onDisconnect!")
        }

        helper!.onDisconnected = { error in
            XCTAssertNotNil(error)
            self.calledOnDisconnected = true
        }

        helper!.connect("ws://localhost:8080")
        XCTAssert(calledOnDisconnected)
    }

    func testWebSocketHelperDisconnectConnected() {
        var connected = false
        helper!.onConnected = { transport in
            connected = transport.isConnected()
            self.calledOnConnected = true
        }

        helper!.onDisconnected = { error in
            XCTAssertNil(error)
            self.calledOnDisconnected = true
        }

        helper!.connect("ws://localhost:8080")
        helper!.disconnect()

        XCTAssert(connected)
        XCTAssert(calledOnConnected)
        XCTAssert(calledOnDisconnected)
    }

    func testWebSocketHelperDisconnectUnconnected() {
        helper!.onConnected = { transport in
            XCTFail("onConnected should not have been called!")
        }

        helper!.onDisconnected = { error in
            self.calledOnDisconnected = true
            XCTAssertNil(error)
        }

        helper!.disconnect()

        XCTAssert(calledOnDisconnected)
    }

    func testWebSocketTransportSendString() {
        helper!.onConnected = { transport in
            transport.sendString("hello world!")
        }

        helper!.connect("ws://localhost:8080")

        XCTAssertEqual("hello world!", mockSocket!.getStringReceived())
    }

    func testWebSocketTransportSendData() {
        helper!.onConnected = { transport in
            transport.sendData(("hello world!").data(using: String.Encoding.ascii)!)
        }

        helper!.connect("ws://localhost:8080")

        XCTAssertEqual("hello world!", NSString(data: mockSocket!.getDataReceived()!, encoding: String.Encoding.ascii.rawValue)!)
    }

    func testWebSocketTransportOnData() {
        helper!.onConnected = { transport in
            var mutableTransport = transport
            NSLog("mutable: \(mutableTransport), immutable: \(transport)")
            mutableTransport.onReceive = { data in
                XCTAssertEqual("hello world!", NSString(data: data, encoding: String.Encoding.ascii.rawValue)!)
                self.calledOnReceived = true
            }
        }

        helper!.connect("ws://localhost:8080")

        mockSocket?.receiveData("hello world!".data(using: String.Encoding.ascii)!)

        XCTAssert(calledOnReceived)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
