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

// Code generated on 2016-12-16 15:32:01.949155. DO NOT MODIFY

public class PlayMode: NSObject, Serializable {
    public var repeat_: Bool?
    public var repeatOne: Bool?
    public var shuffle: Bool?
    public var crossfade: Bool?

    public convenience init(repeat_: Bool?, repeatOne: Bool?, shuffle: Bool?, crossfade: Bool?) {
        self.init()
        self.repeat_ = repeat_
        self.repeatOne = repeatOne
        self.shuffle = shuffle
        self.crossfade = crossfade
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "repeat" {
            self.repeat_ = value as? Bool
        } else if key == "repeatOne" {
            self.repeatOne = value as? Bool
        } else if key == "shuffle" {
            self.shuffle = value as? Bool
        } else if key == "crossfade" {
            self.crossfade = value as? Bool
        }
    }
}
