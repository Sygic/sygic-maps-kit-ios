//// SYMKSearchModelTests.swift
// 
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Quick
import Nimble
import SygicMaps
@testable import SygicMapsKit

class SYMKSearchModelTest: QuickSpec {
    
    override func spec() {
        
        describe("Search Model") {
        
            beforeEach {
                let appKey = ProcessInfo.processInfo.environment["SDK_APP_KEY"] ?? ""
                let appSecret = ProcessInfo.processInfo.environment["SDK_APP_SECRET"] ?? ""
                let appRouting = ProcessInfo.processInfo.environment["SDK_APP_ROUTING"] ?? ""
                SYMKApiKeys.set(appKey: appKey, appSecret: appSecret, routingKey: appRouting)
                
                var initializationResult: Bool?
                SYMKSdkManager.shared.initializeIfNeeded({ (result) in
                    initializationResult = result
                })
                expect(initializationResult).toEventually(equal(true), timeout: 5)
            }
            
            context("Searching") {
                it("shouldReturnSuccess") {
                    var searchError: NSError?
                    var searchResults = [SYSearchResult]()
                    let searchModel = SYMKSearchModel(maxResultsCount: 10, location: nil)
                    searchModel.search(with: "Eurovea") { (results, error) in
                        searchError = error as NSError?
                        searchResults.append(contentsOf: results)
                    }
                    expect(searchError?.code).toEventually(equal(NSRequestResultErrorSuccess), timeout: 5)
                    expect(searchResults.count).toEventually(beGreaterThan(0))
                }
                
//                it("shouldReturnOneResults") {
//                    var multipleResults = [[SYSearchResult]]()
//                    let searchModel = SYMKSearchModel(maxResultsCount: 10, location: nil)
//                    searchModel.search(with: "Eurov", response: { (results: [SYSearchResult], state: SYRequestResultState) in
//                        multipleResults.append(results)
//                    })
//                    searchModel.search(with: "Eurovea", response: { (results: [SYSearchResult], state: SYRequestResultState) in
//                        multipleResults.append(results)
//                    })
//                    expect(multipleResults).toEventually(haveCount(1), timeout: 5)
//                }
            }
            
            afterEach {
                SYMKSdkManager.shared.terminate()
            }
            
        }
        
    }
    
}
