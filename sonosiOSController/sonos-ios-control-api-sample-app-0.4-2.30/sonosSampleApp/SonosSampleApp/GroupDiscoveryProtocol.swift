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

protocol GroupDiscoveryListener {
    /**
     * Listener interface to receive events from the GroupDiscoveryInterface.
     */
    func onGroupDiscoveryUpdate(_ groups: [String: [String:String]])
}

/**
 * Interface for Sonos group discovery on the Local Area Network. The objective of any implementation is to find
 * Sonos speaker groups that an application can connect to and control. Contains interface methods to start and stop discovery
 * along with a listener for returning events associated with discovery.
 */
protocol GroupDiscoveryProtocol {
    /**
     * Starts discovering Sonos groups.
     *
     * - returns: `true` if discovery started properly, `false` otherwise.
     */
    func start() -> Bool

    /**
     * Stops discovering Sonos groups.
     *
     * - returns: `true` if discovery stopped properly, `false` otherwise.
     */
    func stop() -> Bool

    /**
     * Registers a listener of type `GroupDiscoveryListener`.
     *
     * - parameter listener: A listener object for accepting events.
     */
    func listen(_ listener: GroupDiscoveryListener)

    /**
     * Unregisters a listener of type `GroupDiscoveryListener`. Only if the listener is among the list
     * of current listeners should the listener be actually removed in any implementation.
     *
     * - parameter listener: A listener object that will no longer accept events.
     */
    func unlisten(_ listener: GroupDiscoveryListener)
}
