//// SYMapSearchResultExtension.swift
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

extension SYMapSearchResult {
    
    /// Detail result request for `SYSearchResult`. `SYSearchResultDetail` doesn't have more information.
    /// You need to cast it to some subclass, to retrieve more information.
    ///
    /// - Parameters:
    ///   - coordinates: Coordinates for search result. In most cases you need coordinates of result, but groups and categories doesn't have coordinates.
    ///                  So coordinates must be set to retrieve point of interests around this location.
    ///   - data: Result closure callback
    ///   - result: Detail result of a `SYSearchResult`.
    public func detail(for coordinates: SYGeoCoordinate? = nil, data: @escaping (_ result: SYSearchResultDetail?) -> ()) {
        let location = self.coordinate ?? coordinates ?? SYPositioning.shared().lastKnownLocation?.coordinate ?? SYGeoCoordinate()
        let search = SYSearch()
        search.start(SYSearchResultDetailRequest(result: self, atLocation: location)) { detail, state in
            _ = search // reference to search instance, so completion block is executed
            data(detail)
        }
    }
    
}
