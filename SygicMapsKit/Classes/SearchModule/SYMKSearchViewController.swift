//// SYMKSearchViewController.swift
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


/// output
public protocol SYMKSearchViewControllerDelegate: class {
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult])
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController)
}

public class SYMKSearchViewController: SYMKModuleViewController {
    
    // MARK: - Public properties
    
    public var resultsViewController: SYUISearchResultsViewController<SYSearchResult> = SYUISearchResultsTableViewController<SYSearchResult>()
    public var searchBarController = SYUISearchBarController()
    public weak var delegate: SYMKSearchViewControllerDelegate?
    
    // MARK: - Private properties
    
    private let model = SYMKSearchModel()
    
    // MARK: - Public methods
    
    override func sygicSDKInitialized() {
        searchBarController.delegate = self
        resultsViewController.interactionBlock = { [weak self] in
            _ = self?.searchBarController.resignFirstResponder()
        }
        resultsViewController.selectionBlock = { [weak self] searchResult in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.searchController(weakSelf, didSearched: [searchResult])
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = searchBarController.becomeFirstResponder()
    }

    public func prefillSearch(with text: String) {
        searchBarController.prefillSearch(with: text)
        search(for: text)
    }

    public func searchCoordinates(coordinates: SYGeoCoordinate?) {
        model.coordinates = coordinates
    }
    
    public func maxResults(count: UInt) {
        model.maxResultsCount = count
    }
    
    public override func loadView() {
        let searchView = SYMKSearchView()
        view = searchView
    
        addChild(searchBarController)
        searchView.setupSearchBarView(searchBarController.view)
        
        addChild(resultsViewController)
        searchView.setupResultsView(resultsViewController.view)
    }
    
    // MARK: - Private methods
    
    private func search(for query: String) {
        model.search(with: query) { [weak self] (results, state) in
            self?.resultsViewController.data = results
        }
    }
    
}

extension SYMKSearchViewController: SYUISearchBarDelegate {
    
    public func search(textDidChange searchedText: String) {
        // updateResultsWith()
        search(for: searchedText)
    }
    
    public func searchDidBeginEditing() { }
    
    public func searchDidEndEditing() { }
    
    public func searchSearchButtonClicked() {
        delegate?.searchController(self, didSearched: resultsViewController.data)
    }
    
    public func searchCancelButtonClicked() {
        delegate?.searchControllerDidCancel(self)
    }
    
}
