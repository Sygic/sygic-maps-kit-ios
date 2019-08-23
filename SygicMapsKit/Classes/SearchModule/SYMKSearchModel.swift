//// SYMKSearchModel.swift
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

import Foundation
import SygicMaps

class SYMKSearchModel {
    
    // MARK: - Public Properties
    
    static let maxResultsDefault: UInt = 10
    
    /// Search find results around this coordinates. If they are not set, search engine will find best results all around the world.
    public var location: SYGeoCoordinate?
    
    /// Max number of results search returns.
    public var maxResultsCount = SYMKSearchModel.maxResultsDefault
    
    // MARK: - Private Poperties
    
    private var search: SYSearch?
    
    // MARK: - Public Methods

    public init(maxResultsCount: UInt, location: SYGeoCoordinate?) {
        self.location = location
        self.maxResultsCount = maxResultsCount
        search = SYSearch()
    }
    
    /// Method that informs model about sdk initialization, so sdk classes can be initialized.
    public func sdkInitialized() {
        search = SYSearch()
    }
    
    /// Search for results based on query. Searching around `coordinates` set in model.
    /// If `coordinates` are not set, user location coordinates are used.
    ///
    /// If `coordinates` are not set and user location is not valid, search returns empty array of results.
    ///
    /// - Parameters:
    ///   - query: text query for search
    ///   - response: Response closure callback
    ///   - results: Search results based on query.
    ///   - resultState: Result state from search.
    public func search(with query: String, response: @escaping (_ results: [SYSearchResult], _ error: Error?) -> ()) {
        guard !query.isEmpty else {
            response([], NSError(domain: NSRequestResultErrorDomain, code: NSRequestResultErrorSuccess, userInfo: nil))
            return
        }
        let request = SYSearchRequest(query: query, atLocation: location)
        request.maxResultsCount = maxResultsCount
        
        search?.start(request) { (results, error) in
            response(results, error)
        }
    }
    
}
