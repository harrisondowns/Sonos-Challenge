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
import Starscream

/**
 * This class helps to create, open and close WebSockets to be used as a transport in applications.
 */
open class WebSocketHelper {

    /**
     * This class wraps the Starscream `WebSocket` implementation. By wrapping it in the `Socket` protocol we can easily replace
     * it with another implementation or mock it in unit or other levels of testing.
     */
    class WebSocketWrapper: Socket {
        var onError: ((NSError?) -> Void)?
        fileprivate static let CONTROL_API_PROTOCOL = "v1.api.smartspeaker.audio"
        fileprivate static let SONOS_API_KEY = "123e4567-e89b-12d3-a456-426655440000"
        fileprivate static let SONOS_API_KEY_KEY = "X-Sonos-Api-Key"

        /** See `Socket` */
        var onConnect: ((Transport) -> Void)?
        var onDisconnect: ((NSError?) -> Void)?
        var onData: ((Data) -> Void)? {
            didSet {
                webSocket?.onData = self.onData
            }
        }

        /** The WebSocket object that is being wrapped by this implementation. */
        var webSocket: WebSocket?

        /**
         * See `Socket`
         *
         * This implementation makes sure that the device we are talking to is a Sonos player, by checking the SSL certificate
         * provided by the device. This is done in two steps.
         * The first step is to tell the WebSocket to accept self-signed certificates. The second step is to point the
         * `WebSocket` object to the certificates that should be accepted in the program bundle.
         *
         * For more details see
         * [https://developer.sonos.com/control-api/connect/](https://developer.sonos.com/control-api/connect/)
         */
        func connect(_ address: String) {
            let url: URL = URL(string: address)!
            if webSocket == nil {
                webSocket = WebSocket(url: url, protocols: [WebSocketWrapper.CONTROL_API_PROTOCOL])
            }

            webSocket!.origin = nil // don't send an origin header to the player

            webSocket!.onConnect = {
                self.onConnect!(WebSocketTransport(socket: self))
            }

            webSocket!.onDisconnect = { error in
                NSLog("Disconnected: \(error)")
                self.onError?(error)
                self.onDisconnect?(error)
            }

            webSocket!.onText = { text in
                self.onData?((text as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }

            // Check certificates
            if url.scheme == "wss" {
                // This disables the first cert validation pass that is
                // hard-coded to use the default iOS trust store that will
                // definitely fail.
                webSocket!.disableSSLCertValidation = true
                // This sets up a second cert validation pass that will
                // use our own root certs (.cer files in our resource bundle).
                let security = SSLSecurity(usePublicKeys: false, disableSSLPinning: true)
                security.validatedDN = false // players do not have fixed hostnames, so disable DN validation
                webSocket!.security = security
            }

            // Add the Sonos API Key header
            webSocket!.headers[WebSocketWrapper.SONOS_API_KEY_KEY] = WebSocketWrapper.SONOS_API_KEY

            webSocket!.connect()
        }

        /**
         * See `Socket`
         */
        func sendString(_ str: String) {
            webSocket!.write(string: str)
        }

        /**
         * See `Socket`
         */
        func sendData(_ data: Data) {
            webSocket!.write(data: data)
        }

        /**
         * See `Socket`
         */
        func disconnect() {
            webSocket?.disconnect()
        }

        /**
         * See `Socket`
         */
       func isConnected() -> (Bool) {
            return (webSocket?.isConnected)!
        }
    }

    /** This instance parameter is the onError handler which will be executed in the event of a connection error. */
    open var onError: ((NSError?) -> Void)? {
        didSet {
            if let socketWrapper = self.socket as? WebSocketWrapper {
                socketWrapper.onError = self.onError
            }
        }
    }

    /** This instance parameter is the `Socket` protocol the helper creates and uses */
    var socket: Socket?

    /**
     * This instance parameter is the handler for completion of connections. Whenever it is set, we need to map it to the
     * underlying socket.
     */
    open var onConnected: ((Transport) -> (Void)) = { transport in } {
        didSet { socket!.onConnect = self.onConnected; }
    }


    /**
     * This instance parameter is the handler for disconnections of the socket. Whenever it is set, we need to map it to the
     * underlying socket.
     */
    open var onDisconnected: ((NSError?) -> (Void)) = { error in } {
        didSet { socket!.onDisconnect = self.onDisconnected; }
    }

    /**
     * This initializer is allows creation of this class with other Socket implementations. This would usually be used for
     * testing.
     */
    public init(socket: Socket) {
        self.socket = socket
    }

    /**
     * This default initializer creates a WebSocketWrapper for the Socket implementation using the Starscream WebSocket
     * implementation.
     */
    public init() {
        setup()
    }

    open func setup() {
        socket = WebSocketWrapper()
    }

    /**
     * Connects a WebSocket and returns an object that can be used as a transport for sending and receiving
     * data.
     */
    open func connect(_ address: String) {
        socket!.connect(address)
    }

    /**
     * Disconnects the underlying WebSocket for a `Transport` object if it's of the right type.
     */
    open func disconnect() {
        // If this is a user initiated disconnect, then we don't wish to fire any error callbacks.
        if let socketWrapper = self.socket as? WebSocketWrapper {
            socketWrapper.onError = nil
        }

        socket?.disconnect()
        socket = nil
    }
}
