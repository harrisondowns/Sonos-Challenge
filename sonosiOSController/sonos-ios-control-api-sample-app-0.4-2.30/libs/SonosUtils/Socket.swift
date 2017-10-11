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
 * This protocol represents the basic operations performed on a socket used for communicating over a network. The main reason for
 * this class is to allow any implementation of a socket to be wrapped in a common interface. This facilitates both the replacing
 * of one implementation with another and mocking for testing purposes.
 */
public protocol Socket {

    /**
     * This instance parameter holds a handler for completing connections of the socket. It returns a transport which the user
     * can use to send and receive data. See `Transport`.
     *
     * - parameter transport: A transport object for sending and receiving data over a socket
     */
    var onConnect: ((Transport) -> Void)? { get set }

    /**
     * This instance parameter holds a handler for disconnections of the socket. These disconnections can be either from the near
     * or far end. It returns an error object that describes why the far end disconnected, or nil if the near end client
     * explicitly ended the connection. In addition, this method may be called in the case of an unsuccessful connection.
     *
     * - parameter error: An error object that hold information about why the far end disconnected, or nil for the
     * near end.
     */
    var onDisconnect: ((NSError?) -> Void)? { get set }

    /**
     * This instance parameter holds a handler for receiving incoming data. This data can be of any form representable by the
     * NSData class.
     *
     * - parameter data: The data received over the wire from the far end.
     */
    var onData: ((Data) -> Void)? { get set }

    /**
     * Starts the process of connecting a socket to the address given. If it succeeds `onConnect` is called and
     * passed a `Transport` object. If connection is not successful, then `onDisconnect` is called with an appropriate error
     * object describing why the connection could not be made.
     *
     * - parameter address: The URI for the socket to connect to.
     */
    func connect(_ address: String)

    /**
     * Disconnects the socket, ending all further communication. After calls to this function, the transport object passed into
     * `onConnect` should no longer send or receive data.
     */
    func disconnect()

    /**
     * Sends data as a string over the socket.
     *
     * - parameter str: Holds the data to be sent over the socket.
     */
    func sendString(_ str: String)

    /**
     * Sends data stored in an NSData object over the socket.
     *
     * - parameter data: Holds the data to be sent over the socket.
     */
    func sendData(_ data: Data)

    /**
     * Returns the current connection state of the socket. Once a socket transitions from the connected to the
     * disconnected state, it should not go back to the connected state.
     *
     * - returns: `true` if the socket is still connected, and `false` otherwise.
     */
    func isConnected() -> (Bool)
}
