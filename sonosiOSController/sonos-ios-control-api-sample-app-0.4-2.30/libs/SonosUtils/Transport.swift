//
// The MIT License (MIT)
//
// Copyright (c) 2015 Sonos, Inc.
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

/**
 * This protocol represents actions users will take to send data, usually JSON, over a network transport. The main
 * operations are sending and receiving data. Sending data is done through a method call, while receiving data is
 * handled via a handler passed in as a closure. In addition, there is an event handler for transport disconnections.
 */
 public protocol Transport {
    // This member variable holds a callback for receiving data sent to the transport.
    var onReceive: ((Data) -> Void)? { get set }

    /**
     * Allows users of the protocol to send binary data on the transport.
     *
     * - parameter data: Holds the binary data to be sent on the transport.
     */
    func sendData(_ data: Data)

    /**
     * Allows users of the protocol to send string data on the transport.
     *
     * - parameter data: Holds the string data to be sent on the transport.
     */
    func sendString(_ data: String)

    func isConnected() -> (Bool)
}
