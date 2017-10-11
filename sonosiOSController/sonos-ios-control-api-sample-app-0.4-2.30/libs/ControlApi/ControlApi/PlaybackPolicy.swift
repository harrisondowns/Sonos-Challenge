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

// Code generated on 2016-12-16 15:32:01.947811. DO NOT MODIFY

public class PlaybackPolicy: NSObject, Serializable {
    public var canSkip: String?
    public var canSkipBack: Bool?
    public var canSeek: Bool?
    public var canSkipToItem: Bool?
    public var canRepeat: Bool?
    public var canRepeatOne: Bool?
    public var canCrossfade: Bool?
    public var canShuffle: Bool?
    public var canResume: Bool?
    public var pauseAtEndOfQueue: Bool?
    public var refreshAuthWhilePaused: Bool?
    public var showNNextTracks: Int?
    public var showNPreviousTracks: Int?

    public convenience init(canSkip: String?, canSkipBack: Bool?, canSeek: Bool?, canSkipToItem: Bool?, canRepeat: Bool?, canRepeatOne: Bool?, canCrossfade: Bool?, canShuffle: Bool?, canResume: Bool?, pauseAtEndOfQueue: Bool?, refreshAuthWhilePaused: Bool?, showNNextTracks: Int?, showNPreviousTracks: Int?) {
        self.init()
        self.canSkip = canSkip
        self.canSkipBack = canSkipBack
        self.canSeek = canSeek
        self.canSkipToItem = canSkipToItem
        self.canRepeat = canRepeat
        self.canRepeatOne = canRepeatOne
        self.canCrossfade = canCrossfade
        self.canShuffle = canShuffle
        self.canResume = canResume
        self.pauseAtEndOfQueue = pauseAtEndOfQueue
        self.refreshAuthWhilePaused = refreshAuthWhilePaused
        self.showNNextTracks = showNNextTracks
        self.showNPreviousTracks = showNPreviousTracks
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "canSkipBack" {
            self.canSkipBack = value as? Bool
        } else if key == "canSeek" {
            self.canSeek = value as? Bool
        } else if key == "canSkipToItem" {
            self.canSkipToItem = value as? Bool
        } else if key == "canRepeat" {
            self.canRepeat = value as? Bool
        } else if key == "canRepeatOne" {
            self.canRepeatOne = value as? Bool
        } else if key == "canCrossfade" {
            self.canCrossfade = value as? Bool
        } else if key == "canShuffle" {
            self.canShuffle = value as? Bool
        } else if key == "canResume" {
            self.canResume = value as? Bool
        } else if key == "pauseAtEndOfQueue" {
            self.pauseAtEndOfQueue = value as? Bool
        } else if key == "refreshAuthWhilePaused" {
            self.refreshAuthWhilePaused = value as? Bool
        } else if key == "showNNextTracks" {
            self.showNNextTracks = value as? Int
        } else if key == "showNPreviousTracks" {
            self.showNPreviousTracks = value as? Int
        }
    }
}
