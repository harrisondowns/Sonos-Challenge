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
import UIKit

/**
 * Implements the logic/filtering necessary to create a good user experience when utilizing the volume API.
 * This limits the rate at which volume commands are sent to the group coordinator, and ignores volume
 * events while interacting with a volume slider.
 */
class VolumePopOverViewController: UIViewController, VolumeListener {
    var sonosVolume: VolumeProtocol?
    fileprivate var ignoreVolumeEvents = false
    fileprivate var lastEventedValue: Int?
    fileprivate var lastVolumeChange: Int?
    fileprivate var lastSentValue: Int?
    fileprivate var volumeOffImage = UIImage(named: "button_volume_off_black")
    fileprivate var volumeUpImage = UIImage(named: "button_volume_up_black")
    // This timer is used to prevent sending more than 1 volume update every 100 ms
    fileprivate var updateBufferTimer: Timer?
    // This timer is used to send any remaining volume updates after user changes are completed
    fileprivate var staleTimer: Timer?
    // This timer is used to resume processing events from the player after user changes are completed
    fileprivate var resumeEventsTimer: Timer?

    // MARK: Properties
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var fixedVolumeLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!

    // This initialize method facilitates passing in all the parameters needed to use this ViewController
    func initialize(_ sonosVolume: VolumeProtocol) {
        self.sonosVolume = sonosVolume
    }

    /**
     * Once the view is done initializing, set the bar to the correct level and fixed state.
     * If volume states or level was not passed in, then make a getVolume request.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        sonosVolume?.volumeListener = self
        fixedVolumeLabel.isHidden = true
        volumeSlider.isHidden = true
        muteButton.isHidden = true
        sonosVolume?.getCachedVolume()
    }

    // If this view is being dismissed, set the sonosVolume listener to the parent view's implementation.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // This callback nils out the updateBufferTimer instance variable so it can easily be checked for completion.
    func timerAction() {
        updateBufferTimer = nil
    }

    /**
     * This callback sends any remaining volume updates 100 ms after volume changes stop being received
     * from the user.
     */
    func sendFinalValue() {
        NSLog("Stale timer fired")
        if let lastVolumeChange = self.lastVolumeChange {
            sonosVolume?.setVolume(lastVolumeChange)
        }
    }

    /**
     * This callback resumes the processing of volume events from the player 3 seconds after volume
     * changes stop being received from the user.
     */
    func resumeEvents() {
        NSLog("Resuming events")
        let currentValue = Int(self.volumeSlider.value)
        if let lastEventedValue = self.lastEventedValue {
            if lastEventedValue != currentValue {
                self.volumeSlider.setValue(Float(lastEventedValue), animated: true)
            }
        }
        ignoreVolumeEvents = false
        lastSentValue = -1
    }

    /**
     * This handler shows the latest volume level, if the user is not currently interacting with the
     * volume slider.
     */
    func onGroupVolume(_ muted: Bool?, fixed: Bool?, volume: Int?) {
        volumeSlider.isHidden = (fixed == true)
        fixedVolumeLabel.isHidden = (fixed == false)

        muteButton.setBackgroundImage(muted == true ? volumeOffImage : volumeUpImage, for: UIControlState())
        muteButton.isHidden = false

        lastEventedValue = volume

        // ignore events while dragging and for a while after
        if !ignoreVolumeEvents, let volume = volume {
            self.volumeSlider.setValue(Float(volume), animated: true)
        }

    }

    // MARK: Actions

    /**
     * This callback is used when the volume slider is moved by the user. This sends a command to update
     * the volume every 100 ms, and when no more changes are received, it will send any remaining volume
     * updates after 100 ms.
     */
    @IBAction func volumeChanged(_ sender: AnyObject) {
        lastVolumeChange = Int(self.volumeSlider.value) // keep track of the latest change from user
        if let lastVolumeChange = self.lastVolumeChange {
            staleTimer?.invalidate() // only fire staleTimer if nothing is received within 100 ms

            if updateBufferTimer == nil {
                if lastSentValue != lastVolumeChange {
                    sonosVolume?.setVolume(lastVolumeChange)
                    lastSentValue = lastVolumeChange
                    // send at most one action every 100 milliseconds
                    updateBufferTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                                               selector: #selector(VolumePopOverViewController.timerAction),
                                                                               userInfo: nil, repeats: false)
                }
            } else {
                // guarantees that we'll send the final state if nothing is received within 100 ms
                staleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                                    selector: #selector(VolumePopOverViewController.sendFinalValue),
                                                                    userInfo: nil, repeats: false)
            }
        }

    }

    // This callback is used when the user touches the volume slider thumb.
    @IBAction func volumeTouchDown(_ sender: AnyObject) {
        NSLog("Volume touch down")
        resumeEventsTimer?.invalidate() // if we start dragging again before the timer expires, cancel it
        ignoreVolumeEvents = true
    }

    // This callback is used when the user stops touching the volume slider thumb within the bounds of the view.
    @IBAction func volumeTouchUp(_ sender: AnyObject) {
        NSLog("Volume touch up")
        sonosVolume?.setVolume(Int(self.volumeSlider.value))
        // group volume changes can be slow, keep ignoring events for three more seconds
        resumeEventsTimer =  Timer.scheduledTimer(timeInterval: 3, target: self,
                                                              selector: #selector(VolumePopOverViewController.resumeEvents),
                                                              userInfo: nil, repeats: false)
    }

    // This callback is used when the user stops touching the volume slider thumb outside the bounds of the view.
    @IBAction func volumeTouchUpOutside(_ sender: AnyObject) {
        volumeTouchUp(sender)
    }

    // This callback is used when the user presses the mute/unmute icon.
    @IBAction func muteButtonPressed(_ sender: AnyObject) {
        sonosVolume?.toggleMute()
    }

}
