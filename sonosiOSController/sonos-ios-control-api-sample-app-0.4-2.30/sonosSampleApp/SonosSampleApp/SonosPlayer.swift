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
import SonosUtils
import Foundation
import ControlApi

/**
 * Controls a Sonos player that is a group coordinator. See `PlaybackProtocol`.
 * Controls volume for a Sonos player that is a group coordinator. See `VolumeProtocol`.
 */
class SonosPlayer: NSObject, GroupProtocol, SonosGlobalProtocol, PlaybackProtocol, VolumeProtocol {
    var transport: Transport?
    var webSocketHelper: WebSocketHelper?
    var serializer: ControlApi.JsonSerializer = ControlApi.JsonSerializer()

    var webSocketAddress: String?
    var groupId: String?
    var householdId: String?
    var groupName: String?

    var groupListener: GroupListener?
    var sonosGlobalListener: SonosGlobalListener?
    var playbackListener: PlaybackListener?
    var volumeListener: VolumeListener?

    var socketExpirationTimer: Timer?

    var isPlaying: Bool = false

    fileprivate var cachedVolume: Int?
    fileprivate var cachedMuteState: Bool?
    fileprivate var cachedFixedVolumeState: Bool?

    fileprivate var connected: Bool = false

    init(address: String?, groupId: String?, householdId: String?, groupName: String?) {
        super.init()
        self.webSocketAddress = address
        self.groupId = groupId
        self.householdId = householdId
        self.groupName = groupName
        setup()
        self.initialize(address, groupId: groupId, householdId: householdId)
    }

    func setup() {
        webSocketHelper = WebSocketHelper()
    }

    fileprivate func initialize(_ address: String?, groupId: String?, householdId: String?) {
        if let vAddress = address {
            NSLog("Connecting to: \(vAddress)")

            webSocketHelper?.onDisconnected = { error in
                self.connected = false
            }

            webSocketHelper?.onConnected = { transport in
                self.cleanup()
                NSLog("Connected")
                self.connected = true
                self.transport = transport

                self.transport?.onReceive = { data in

                    self.cleanup()

                    let jsonData = String(data: data, encoding: String.Encoding.utf8)!
                    NSLog("Received: %@", jsonData)

                    // deserialize a json string into a message object in ControlApi
                    do {
                        let message = try self.serializer.fromJson(jsonData)
                        if let vMessage = message as BaseMessage! {
                            self.onEvent(vMessage)
                        }
                    } catch {
                        NSLog("Deserialization of message body failed.")
                    }

                }

                let command = Playback.Subscribe(groupId: groupId, householdId: householdId, cmdId: nil)
                self.sendCommand(command)

                let metaDatacommand = PlaybackMetadata.Subscribe(groupId: groupId, householdId: householdId, cmdId: nil)
                self.sendCommand(metaDatacommand)

                let groupVolumeSubscribeCommand = GroupVolume.Subscribe(groupId: groupId, householdId: householdId, cmdId: nil)
                self.sendCommand(groupVolumeSubscribeCommand)
            }


            webSocketHelper?.connect(vAddress)
            socketExpirationTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                                                           selector: #selector(SonosPlayer.timeoutHandler),
                                                                           userInfo:nil, repeats: false)
        }
    }

    func setVolume(_ volume: Int) {
        let command = GroupVolume.SetVolume(groupId: groupId, householdId: householdId,
                                            cmdId: nil, body: GroupVolume.SetVolume.SetVolumeBody(volume: volume))
        sendCommand(command)
    }

    func getVolume() {
        let command = GroupVolume.GetVolume(groupId: groupId, householdId: householdId, cmdId: nil)
        sendCommand(command)
    }

    func setMute(_ muted: Bool) {
        let command = GroupVolume.SetMute(groupId: groupId, householdId: householdId,
                                          cmdId: nil, body: GroupVolume.SetMute.SetMuteBody(muted: muted))
        sendCommand(command)
    }

    // This method sends a setMute command to toggle the current mute state of the group.
    func toggleMute() {
        if let muted = cachedMuteState {
            setMute(!muted)
        }
    }

    /**
     * Returns cached volume states and level to onGroupVolume() if available,
     * requests an update from the group coordinator otherwise.
     */
    func getCachedVolume() {
        if let cachedMuteState = self.cachedMuteState, let cachedFixedVolumeState = self.cachedFixedVolumeState,
            let cachedVolume = self.cachedVolume {
            volumeListener?.onGroupVolume(cachedMuteState, fixed: cachedFixedVolumeState, volume: cachedVolume)
        } else {
            getVolume()
        }
    }

    func play() {
        let command = Playback.Play(groupId: groupId, householdId: householdId, cmdId: nil)
        sendCommand(command)
    }

    func pause() {
        let command = Playback.Pause(groupId: groupId, householdId: householdId, cmdId: nil)
        sendCommand(command)
    }

    func goToNextTrack() {
        let command = Playback.SkipToNextTrack(groupId: groupId, householdId: householdId, cmdId: nil)
        sendCommand(command)
    }

    func goToPreviousTrack() {
        let command = Playback.SkipToPreviousTrack(groupId: groupId, householdId: householdId, cmdId: nil)
        sendCommand(command)
    }

    func sendCommand(_ commandObject: Serializable, timeoutSeconds: Double = 5) {
        if connected {
            do {
                let jsonString = try self.serializer.toJson(commandObject)
                NSLog("Sending: " + jsonString)
                self.transport?.sendString(jsonString)

                /** Invalidate any timeouts scheduled since we only care about timing out after the last
                 command sent. */
                cleanup()

                // Schedule a timeout to fire in 5 seconds if the group coordinator doesn't respond.
                socketExpirationTimer = Timer.scheduledTimer(
                    timeInterval: timeoutSeconds, target: self, selector: #selector(SonosPlayer.timeoutHandler), userInfo:nil, repeats: false)
            } catch let exception {
                NSLog("\(exception)")
            }
        }
    }

    // Handler for when a group coordinator ceases to respond in a timely manner.
    func timeoutHandler() {
        if let vPlaybackListener = playbackListener {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let userInfo = [ NSLocalizedDescriptionKey: "Timed out contacting group coordinator"]
                vPlaybackListener.onConnectionError(NSError(domain: appDelegate.DOMAIN, code: 101, userInfo: userInfo))
            }
        }
    }

    // Shuts down and cleans any expirationtimer currently running.
    func cleanup() {
        self.socketExpirationTimer?.invalidate()
        self.socketExpirationTimer = nil
    }

    func disconnect() {
        self.cleanup()
        webSocketHelper?.disconnect()
    }

    func onGroupCoordinatorChanged(_ body: Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody) {
        if let groupStatus = body.groupStatus {
            switch groupStatus {
            case "GROUP_STATUS_UPDATED":
                if let groupName = body.groupName {
                    NSLog("Group name updated to '\(groupName.uppercased())'.")
                    self.groupName = groupName
                    groupListener?.onGroupCoordinatorUpdated(groupName)
                }
            case "GROUP_STATUS_MOVED":
                if let websocketUrl = body.websocketUrl {
                    NSLog("Group coordinator moved, disconnecting and connecting to '\(websocketUrl)'.")

                    self.webSocketAddress = websocketUrl
                    self.disconnect()
                    setup()
                    initialize(self.webSocketAddress, groupId: self.groupId, householdId: self.householdId)

                    if let groupName = body.groupName {
                        self.groupName = groupName
                        groupListener?.onGroupCoordinatorUpdated(groupName)
                    } else {
                        NSLog("Received a GROUP_STATUS_MOVED event with no groupName provided.")
                    }
                    if let playerId = body.playerId {
                        groupListener?.onGroupCoordinatorMoved(playerId)
                    }
                }
            case "GROUP_STATUS_GONE":
                NSLog("Group coordinator gone. Disconnecting from websocket.")
                self.disconnect()
                groupListener?.onGroupCoordinatorGone(self.groupName)
            default:
                NSLog("There was an unhandled groupCoordinatorChanged event: \(body.groupStatus!).")
            }
        }
    }

    func onEvent(_ message: BaseMessage) {
        switch message.body {
        case let messageBody as Playback.PlaybackStatus.PlaybackStatusBody:
            self.isPlaying = (messageBody.playbackState == "PLAYBACK_STATE_PLAYING" ||
                messageBody.playbackState == "PLAYBACK_STATE_BUFFERING")
            playbackListener?.onPlayStatusChanged(self.isPlaying)
        case let messageBody as PlaybackMetadata.MetadataStatus.MetadataStatusBody:
            let currentItem = messageBody.currentItem
            if let track = currentItem?.track {
                if let imageUrl = track.imageUrl {
                    NSLog("%@", imageUrl)
                }
                playbackListener?.onMetadataChanged(track.name, artist: track.artist?.name, album: track.album?.name,
                                                    imageUrl: track.imageUrl)
            } else {
                playbackListener?.onMetadataChanged( nil, artist: nil, album: nil, imageUrl: nil)
            }
        case let messageBody as Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody:
            onGroupCoordinatorChanged(messageBody)
        case let messageBody as GroupVolume.GroupVolume.GroupVolumeBody:
            if let muted = messageBody.muted, let fixed = messageBody.fixed, let volume = messageBody.volume {
                cachedVolume = volume
                cachedMuteState = muted
                cachedFixedVolumeState = fixed
                volumeListener?.onGroupVolume(muted, fixed: fixed, volume: volume)
            }
        case let messageBody as Playback.PlaybackError.PlaybackErrorBody:
            playbackListener?.onPlaybackError(messageBody.errorCode, reason: messageBody.reason)
        case let messageBody as GlobalError:
            sonosGlobalListener?.onGlobalError(messageBody.errorCode, reason: messageBody.reason)
        default:
            break
        }
    }

    func isConnected() -> Bool {
        return connected
    }
}
