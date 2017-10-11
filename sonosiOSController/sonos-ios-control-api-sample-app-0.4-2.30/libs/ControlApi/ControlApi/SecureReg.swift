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

// Code generated on 2016-12-16 15:32:01.948285. DO NOT MODIFY

public class SecureReg: NSObject, Serializable {
    public var regState: Int?
    public var customerId: String?
    public var householdId: String?
    public var regToken: String?
    public var timeout: Int?
    public var macAddr: String?
    public var hmacDigest: String?

    public convenience init(regState: Int?, customerId: String?, householdId: String?, regToken: String?, timeout: Int?, macAddr: String?, hmacDigest: String?) {
        self.init()
        self.regState = regState
        self.customerId = customerId
        self.householdId = householdId
        self.regToken = regToken
        self.timeout = timeout
        self.macAddr = macAddr
        self.hmacDigest = hmacDigest
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "regState" {
            self.regState = value as? Int
        } else if key == "timeout" {
            self.timeout = value as? Int
        }
    }
}
