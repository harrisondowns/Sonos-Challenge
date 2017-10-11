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

import Starscream

/**
 * This class is an implementation of the `Transport` protocol for sending data over a `WebSocket`. For details about the
 * WebSocket library we are using see [https://github.com/daltoniam/starscream](https://github.com/daltoniam/starscream).
 *
 * This class is not meant to be directly instantiated, but rather indirectly through the `WebSocketHelper` class. That class
 * handles opening and closing connections and then creating instances of this class once the connection is established.
 * In this way users of this class will never be handed a transport object that is in an invalid state unless the connections
 * were closed by the far end.
 */
open class WebSocketTransport: Transport {
    // This data member is the actual underlying socket used as a transport.
    fileprivate var socket: Socket?

    /**
     * @see Transport.onReceive
     */
    open var onReceive: ((Data) -> Void)? {
        didSet {
            self.socket?.onData = { data in
                self.onReceive?(data as Data)
            }
        }
    }

    /**
     * This module protected initializer allows the `WebSocketHelper` to initialize instances without exposing direct
     * initialization in other modules. It takes a connected `Starscream.WebSocket` and wraps it to act as the transport.
     *
     * - parameter socket This parameter is a connected WebSocket that will act as a transport.
     */
    public init(socket: Socket) {
        self.socket = socket
    }

    public init() {
    }

    /**
     * See `Transport.sendData`
     */
    open func sendData(_ data: Data) {
        socket?.sendData(data)
    }

    /**
     * See `Transport.sendString`
     */
    open func sendString(_ data: String) {
        socket?.sendString(data)
    }

    /**
     * This module protected function allows the `WebSocketHelper` to close the connection without directly exposing this
     * capability to classes in other modules.
     */
    open func disconnect() {
        socket?.disconnect()
    }

    open func isConnected() -> (Bool) {
        return (socket?.isConnected())!
    }
}
