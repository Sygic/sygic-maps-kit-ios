//// SYMKApiKeys.swift
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


/// Define API keys for using Sygic Maps SDK.
/// Obtain keys - http://www.sygic.com/enterprise/get-api-key/
public class SYMKApiKeys {

    static private(set) var appKey = ""
    static private(set) var appSecret = ""
    
    /// Set application key and application secret obtained by Sygic SDK.
    ///
    /// - Parameters:
    ///   - appKey: Application key.
    ///   - appSecret: Application secret.
    static public func set(appKey: String, appSecret: String) {
        SYMKApiKeys.appKey = appKey
        SYMKApiKeys.appSecret = appSecret
    }
    
}
