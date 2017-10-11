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
 * Finds Sonos groups that the application can connect to on the Local Area Network via SSDP.
 */
class SonosGroupDiscovery: NSObject, GroupDiscoveryProtocol, GCDAsyncUdpSocketDelegate {
    static let WEBSOCKET_KEY = "WEBSOCK.SMARTSPEAKER.AUDIO"
    static let HOUSEHOLD_KEY = "HOUSEHOLD.SMARTSPEAKER.AUDIO"
    static let GROUP_KEY = "GROUPINFO.SMARTSPEAKER.AUDIO"
    static let USN_KEY = "USN"
    static let NTS_KEY = "NTS"
    static let BOOT_ID_KEY = "BOOTID.UPNP.ORG"
    static let CONFIG_ID_KEY = "CONFIGID.UPNP.ORG"
    static let CACHE_CONTROL_KEY = "CACHE-CONTROL"

    static let PLAYER_UUID_KEY = "uuid"
    static let GROUP_ID_KEY = "gid"
    static let GROUP_COORDINATOR_KEY = "gc"
    static let GROUP_NAME_KEY = "gname"
    static let MAX_AGE_KEY = "max-age"

    static let MULTICAST_SSDP_IP = "239.255.255.250"
    static let BROADCAST_SSDP_IP = "255.255.255.255"
    fileprivate static let SEARCH_TARGET = "urn:smartspeaker-audio:service:SpeakerGroup:1"

    fileprivate static let SSDP_PORT: UInt16 = 1900

    fileprivate static let SEND_TIMEOUT = 1.0
    fileprivate static let MSEARCH_INTERVAL: Int64 = 1000 * 1000 * 1000

    /// SSDP M-SEARCH request for Sonos groups
    static let discoveryMessage =
        "M-SEARCH * HTTP/1.1\r\n" +
        "HOST: \(SonosGroupDiscovery.MULTICAST_SSDP_IP):\(SonosGroupDiscovery.SSDP_PORT)\r\n" +
        "USER-AGENT: iOS/version SonosSampleApp/1.0\r\n" +
        "ST: \(SonosGroupDiscovery.SEARCH_TARGET)\r\n" +
        "MAN: \"ssdp:discover\"\r\n" +
        "MX: 1\r\n\r\n"

    fileprivate static let expectedKeys: [String: Bool] =
        [WEBSOCKET_KEY: true, HOUSEHOLD_KEY: true, GROUP_KEY: true, USN_KEY: true, NTS_KEY: true,
         BOOT_ID_KEY: true, CONFIG_ID_KEY: true, CACHE_CONTROL_KEY: true]

    var listener: GroupDiscoveryListener?
    var multicastListeningSocket: GCDAsyncUdpSocket?
    var multicastMsearchSocket: GCDAsyncUdpSocket?
    var broadcastMsearchSocket: GCDAsyncUdpSocket?
    var mSearchMulticastRequestsSent = 0
    var mSearchBroadcastRequestsSent = 0
    var discoveredGroups = [String: [String: String]]()

    static var sonosGroup: SonosGroupDiscovery?

    override init() {
        self.multicastListeningSocket = nil
        self.multicastMsearchSocket = nil
        self.broadcastMsearchSocket = nil

        super.init()

        SonosGroupDiscovery.sonosGroup = self
    }

    convenience init(listener: GroupDiscoveryListener) {
        self.init()
        self.listener = listener
    }

    //======================================= GroupDiscoveryInterface =======================================

    /**
     * Starts discovering Sonos groups.
     *
     * - returns: `true` if discovery started properly, `false` otherwise.
     */
    func start() -> Bool {
        DispatchQueue.main.async {
            self.startMulticastListener()
            self.sendMsearchRequests()
        }

        return true
    }

    /**
     * Stops discovering Sonos groups.
     *
     * - returns: True if discovery stopped properly, false otherwise.
     */
    func stop() -> Bool {
        self.multicastListeningSocket?.close()
        self.multicastMsearchSocket?.close()
        self.broadcastMsearchSocket?.close()

        self.multicastListeningSocket = nil
        self.multicastMsearchSocket = nil
        self.broadcastMsearchSocket = nil

        self.mSearchMulticastRequestsSent = 0
        self.mSearchBroadcastRequestsSent = 0

        return true
    }

    /**
     * Registers a listener of type `GroupDiscoveryListener`.
     *
     * - parameter listener: A listener object for accepting events.
     */
    func listen(_ listener: GroupDiscoveryListener) {
        self.listener = listener
    }

    /**
     * Unregisters a listener of type `GroupDiscoveryListener`. Only if the listener is among the list of
     * current listeners will the listener be actually removed.
     *
     * - parameter listener: A listener object that will no longer accept events.
     */
    func unlisten(_ listener: GroupDiscoveryListener) {
        let l = self.listener!
        if (l as! NSObject) === (listener as! NSObject) {
            self.listener = nil
        }
    }

    //==================================== GCDAsyncUdpSocket Delegate ========================================

    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data,
        withFilterContext filterContext: Any) {
            let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            self.processSsdp(dataStr)
    }

    //==================================== Private Helper Methods ========================================

    /**
     * Parses SSDP messages and stores them if appropriate. If this data was received from a group coordinator, an event
     * is emited to listeners.
     *
     * - parameter ssdp: SSDP message encoded as a string.
     */
    fileprivate func processSsdp(_ ssdp: NSString?) {
        do {
            let speakerRegex = try NSRegularExpression(pattern: "(ST|NT): \(SonosGroupDiscovery.SEARCH_TARGET)",
                options: NSRegularExpression.Options.caseInsensitive)

            let matches = speakerRegex.numberOfMatches(in: ssdp! as String, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                range: NSMakeRange(0, ssdp!.length))
            if matches > 0 {
                var groupValues = self.parseSsdp(ssdp)
                if !groupValues.isEmpty {
                    discoveredGroups.removeValue(forKey: groupValues[SonosGroupDiscovery.PLAYER_UUID_KEY]!)
                    if groupValues[SonosGroupDiscovery.NTS_KEY] != "ssdp:byebye" {
                        discoveredGroups[groupValues[SonosGroupDiscovery.PLAYER_UUID_KEY]!] = groupValues
                    }
                    self.listener?.onGroupDiscoveryUpdate(discoveredGroups)
                }
            }
        } catch {

        }
    }

    /**
     * Parses SSDP messages and constructs a usable data structure with the information retrieved.
     *
     * - parameter ssdp: SSDP string with data about a group.
     */
    fileprivate func parseSsdp(_ ssdp: NSString?) -> [String: String] {
        var groupValues = [String: String]()

        // Separate the string into individual lines of text
        let lines = CFStringTokenizerCreate(kCFAllocatorDefault, ssdp! as CFString, CFRangeMake(0, ssdp!.length),
            UInt(kCFStringTokenizerUnitParagraph), CFLocaleCopyCurrent())
        
        var tokenType = CFStringTokenizerAdvanceToNextToken(lines)
        while (tokenType != CFStringTokenizerTokenType()) {
            let lineRange = CFStringTokenizerGetCurrentTokenRange(lines)
            let line: NSString = CFStringCreateWithSubstring(kCFAllocatorDefault, ssdp, lineRange)

            // Separate line into key value pairs
            let delimiterRange = line.range(of: ": ")

            if delimiterRange.location != NSNotFound {
                // Process the key-value pair and add it to groupValues
                let key = line.substring(with: NSRange(location: 0, length: delimiterRange.location))
                let value = line.substring(from: delimiterRange.location +
                    delimiterRange.length).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                if SonosGroupDiscovery.expectedKeys[key] != nil {
                    if key == SonosGroupDiscovery.GROUP_KEY {
                        let groupInfo = parseGroupInfo(value)
                        groupValues[SonosGroupDiscovery.GROUP_COORDINATOR_KEY] = groupInfo.gc
                        groupValues[SonosGroupDiscovery.GROUP_ID_KEY] = groupInfo.gid
                        groupValues[SonosGroupDiscovery.GROUP_NAME_KEY] = groupInfo.gname
                    } else if key == SonosGroupDiscovery.USN_KEY {
                        let usnInfo = parseUsnInfo(value)
                        groupValues[usnInfo.uuid] = usnInfo.value
                    } else if key == SonosGroupDiscovery.CACHE_CONTROL_KEY {
                        let cacheInfo = parseCacheControlInfo(value)
                        groupValues[cacheInfo.maxAge] = cacheInfo.age
                    } else {
                        groupValues[key] = value
                    }
                }
            }
            tokenType = CFStringTokenizerAdvanceToNextToken(lines)
        }

        return groupValues
    }

    /**
     * Parses the group information, such as ID, name and whether it's the group coordinator, from the
     * `GROUPINFO.SMARTSPEAKER.AUDIO` SSDP header. Returns each of the identified group parameters.
     *
     * - parameter groupStr: Group info string from the SSDP message
     * - returns: `(gc, gid, gname)` where `gc` is 1 if this group is the group coordinator, 0 otherwise. `gid` is the group Id
     * associated with this SSDP message, and `gname` is the name of the group
     */
    fileprivate func parseGroupInfo(_ groupStr: String) -> (gc: String, gid: String, gname: String) {
        let groupInfo = groupStr.split("; ", tokenLimit: 2)

        var gc = ""
        var gid = ""
        var gname = ""

        for info in groupInfo {
            let keyValue = info.split("=", tokenLimit: 1)
            if keyValue.count == 2 {
                let key = keyValue[0]
                var value = keyValue[1]

                if value.characters.count >= 2 {
                    value = value.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                }

                value = value.replacingOccurrences(of: "\\\\",
                    with: "\\").replacingOccurrences(of: "\\\"", with: "\"")

                if key == SonosGroupDiscovery.GROUP_COORDINATOR_KEY {
                    gc = value
                } else if key == SonosGroupDiscovery.GROUP_ID_KEY {
                    gid = value
                } else if key == SonosGroupDiscovery.GROUP_NAME_KEY {
                    gname = value
                }
            }
        }

        return (gc, gid, gname)
    }

    /**
     * Parses the Unique Service Name (USN) header from an SSDP message.
     *
     * - parameter usnInfo: String with USN info
     * - returns: `(uuid, value)` where `uuid` is the UUID key name and `value` is the UUID value
     */
    fileprivate func parseUsnInfo(_ usnInfo: String) -> (uuid: String, value: String) {
        var tokens = usnInfo.components(separatedBy: ":")
        var subTokens = tokens[1].components(separatedBy: "::")

        return (tokens[0], subTokens[0])
    }

    /**
     * Parses the Cache control header from an SSDP message.
     *
     * - parameter cacheInfo: String with Cache control info
     * - returns: `(maxAge, age)` where `maxage` is the maximum age key, and `age` is the value of the
     * maximum age in seconds since the 1970 epoch.
     */
    fileprivate func parseCacheControlInfo(_ cacheInfo: String) ->  (maxAge: String, age: String) {
        var tokens = cacheInfo.components(separatedBy: "=")
        let age = Int(tokens[1].trimmingCharacters(in: CharacterSet.whitespaces))! +
            Int(Date().timeIntervalSince1970)
        return (tokens[0], String(age))
    }

    /**
     * Sends M-SEARCH request messages over multicast and broadcast. This method creates `GCDAsyncUdpSocket`s for
     * both these addresses and then sends the M-SEARCH messages. Once the message is sent, it enables
     * receiving of the responses which are then sent to the `parseSsdp` method.
     *
     * These messages are sent out three times, once every second.
     */
    func sendMsearchRequests() {
        let data = SonosGroupDiscovery.discoveryMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
        // Set up the sockets
        self.multicastMsearchSocket = createAndConfigureSocket(0)
        try self.multicastMsearchSocket?.joinMulticastGroup(SonosGroupDiscovery.MULTICAST_SSDP_IP)

        self.broadcastMsearchSocket = createAndConfigureSocket(0)
        try self.broadcastMsearchSocket?.enableBroadcast(true)

        sendAndStartReceiving(self.multicastMsearchSocket!,
                              withData: data,
                                toHost: SonosGroupDiscovery.MULTICAST_SSDP_IP,
                           withCounter: &self.mSearchMulticastRequestsSent)
        sendAndStartReceiving(self.broadcastMsearchSocket!,
                              withData: data,
                                toHost: SonosGroupDiscovery.BROADCAST_SSDP_IP,
                           withCounter: &self.mSearchBroadcastRequestsSent)
        } catch {

        }
    }

    /**
     * Starts the multicast listeners for keep-alive and bye messages.
     */
    func startMulticastListener() {
        do {
            self.multicastListeningSocket = createAndConfigureSocket(SonosGroupDiscovery.SSDP_PORT)
            try self.multicastListeningSocket?.joinMulticastGroup(SonosGroupDiscovery.MULTICAST_SSDP_IP)

            try self.multicastListeningSocket?.beginReceiving()
        } catch let exception {
            NSLog("\(exception)")
        }
    }

    /**
     * Creates and binds a `GCDAsyncUdpSocket` to the appropriate port for sending and receiving messages.
     *
     * - parameter port: The port the socket will bind to
     * - returns: A `GCDAsyncUdpSocket`
     */
    fileprivate func createAndConfigureSocket(_ port: UInt16) -> GCDAsyncUdpSocket {
        do {
            let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
            try socket?.bind(toPort: port)

            return socket!
        } catch let exception {
            NSLog("\(exception)")
        }

        return GCDAsyncUdpSocket()
    }

    /**
     * Sends a message, specifically an M-SEARCH message, and starts receiving responses.
     *
     * - parameter socket: The socket to send and receive on.
     * - parameter data: Data to send on the socket.
     * - parameter host: Hostname to which the data is sent to.
     * - parameter counter: Counter to limit the number of sends.
     */
    fileprivate func sendAndStartReceiving(_ socket: GCDAsyncUdpSocket, withData data: Data?, toHost host: String?,
        withCounter counter: inout Int) {
            sendMSearchRequest(socket, withData: data, toHost: host, withCounter: &counter, andWait: 0)

            do {
                try socket.beginReceiving()
            } catch let exception {
                NSLog("\(exception)")
            }
    }

    /**
     * Sends an M-SEARCH request once, and then, if less than three have been sent, schedule another send for
     * one second later.
     *
     * - parameter socket: The socket on which to send.
     * - parameter data: The M-SEARCH message to send.
     * - parameter host: The destination address to which the data will be sent.
     * - parameter counter: The number of M-SEARCH requests to be sent.
     * - parameter wait: Time, in nanoseconds, to wait between sends.
     */
     func sendMSearchRequest(_ socket: GCDAsyncUdpSocket, withData data: Data?, toHost host: String?,
        withCounter counter: inout Int, andWait wait: Int64) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(wait) / Double(NSEC_PER_SEC)) {[counter] in
                var counter = counter
                socket.send(data, toHost: host, port: SonosGroupDiscovery.SSDP_PORT,
                    withTimeout: SonosGroupDiscovery.SEND_TIMEOUT, tag: counter)
                counter += 1
                if counter < 3 {
                    self.sendMSearchRequest(socket, withData: data, toHost: host, withCounter: &counter,
                        andWait: SonosGroupDiscovery.MSEARCH_INTERVAL)
                }
            }
    }
}


extension String {

    /**
     * Tokenizes `String`s around a given regular expression up to a certain integer limit greater than 0.
     * - parameter regex: Regular expression string to use for tokenizing.
     * - parameter tokenLimit: Maximum number of tokens to return.
     * - returns: The resulting array of tokens.
     */
    func split(_ regex: String, tokenLimit: Int) -> Array<String> {
        var tokens: [String] = []

        do {
            if tokenLimit > 0 {
                let regularExpression = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options())
                let range = NSMakeRange(0, self.characters.count)
                var tokenCount = 0
                var currentIndex = 0

                regularExpression.enumerateMatches(in: self,
                    options: NSRegularExpression.MatchingOptions(), range: range) { textCheckingResult, matchingFlags, unsafePointer in
                    if let vTextCheckingResult = textCheckingResult {
                        if tokenCount < tokenLimit {
                            tokens.append(self.substring(with: (self.characters.index(self.startIndex, offsetBy: currentIndex) ..< self.characters.index(self.startIndex, offsetBy: vTextCheckingResult.range.location))))

                            if tokenCount == tokenLimit - 1 {
                                tokens.append(self.substring(with: (self.characters.index(self.startIndex, offsetBy: vTextCheckingResult.range.location +
                                        vTextCheckingResult.range.length) ..< self.endIndex)))
                            }

                            currentIndex = vTextCheckingResult.range.location + vTextCheckingResult.range.length

                            tokenCount += 1
                        }
                    }
                }

                if tokens.isEmpty {
                        tokens.append(self.substring(with: (self.characters.index(self.startIndex, offsetBy: currentIndex) ..< self.endIndex)))
                }
            }
        } catch {
            NSLog("\(error)")
        }

        return tokens
    }
}
