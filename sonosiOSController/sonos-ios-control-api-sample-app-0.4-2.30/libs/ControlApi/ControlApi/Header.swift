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

public enum TargetType {
    case GroupId
    case SessionId
    case none
}

open class Header: NSObject, Serializable {
    open var namespace: String?
    open fileprivate(set) var command: String?
    open fileprivate(set) var groupId: String?
    open fileprivate(set) var householdId: String?
    open fileprivate(set) var sessionId: String?
    open fileprivate(set) var cmdId: String?
    open internal(set) var success: Bool?
    open fileprivate(set) var response: String?
    open fileprivate(set) var type: String?


    public convenience init(namespace: String?, command: String?, householdId: String?, targetId: String?=nil,
        targetIdType: TargetType=TargetType.none, cmdId: String?) {
            self.init()
            self.namespace = namespace
            self.command = command
            self.householdId = householdId

            switch targetIdType {
                case TargetType.GroupId:
                    self.groupId = targetId
                case TargetType.SessionId:
                    self.sessionId = targetId
                default:
                    break
            }

            self.cmdId = cmdId
    }

    public convenience init(namespace: String?, targetId: String?=nil, targetIdType: TargetType=TargetType.none,
        householdId: String?, cmdId: String?, success: Bool?, response: String?, type: String?) {
        self.init()
        self.namespace = namespace
        self.householdId = householdId

        switch targetIdType {
            case TargetType.GroupId:
                self.groupId = targetId
            case TargetType.SessionId:
                self.sessionId = targetId
            default:
                break
        }

        self.cmdId = cmdId
        self.success = success
        self.response = response
        self.type = type
    }

    /**
     * This implementation checks if the type name is success and sets their value if it is.
     *
     * See `Serializable` protocol
     */
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "success" {
            self.success = value as? Bool
        } else {
            NSLog("WARNING, undefined field: \(key)")
        }
    }

}
