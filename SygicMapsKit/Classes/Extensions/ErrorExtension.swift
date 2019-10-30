//// SYRequestResultStateExtension.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps
import SygicUIKit

public extension Error {
    func searchErrorMessage() -> String? {
        let error = self as NSError
        guard error.domain == NSRequestResultErrorDomain else { return nil }
        switch error.code {
        case NSRequestResultErrorUnknown:
            return LS("Search error")
        case NSRequestResultErrorNetworkUnavailable:
            return LS("Search not available")
        case NSRequestResultErrorRequestCanceled:
            return LS("Search canceled")
        case NSRequestResultErrorInvalidLocationId:
            return LS("Invalid location Id for search")
        case NSRequestResultErrorInvalidCategoryTag:
            return LS("Invalid category tag for search")
        case NSRequestResultErrorUnauthorized:
            return LS("Search unauthorized")
        case NSRequestResultErrorNetworkUnavailable:
            return LS("Network unavailable")
        case NSRequestResultErrorNetworkTimeout:
            return LS("Network timeout")
        default:
            return LS("Search error")
        }
    }
}
