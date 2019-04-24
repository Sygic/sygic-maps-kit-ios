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


/// Search module output protocol
public protocol SYMKSearchViewControllerDelegate: class {
    
    /// Delegate receives searched data. SYSearchResult contains just type and coordinates of the result.
    /// If coordinates are not set, result is group or category. For more information about search result,
    /// cast it to `SYMapSearchResult` subclass and call `detail` method.
    ///
    /// - Parameters:
    ///   - searchController: Search module controller.
    ///   - results: Array of search results.
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult])
    
    /// Delegate receives information, that user did cancel action.
    ///
    /// - Parameter searchController: Search module controller.
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController)
}

/// Search module.
///
/// A controller that manages searching for point of interests, cities, streets etc.
public class SYMKSearchViewController: SYMKModuleViewController {
    
    // MARK: - Public properties
    
    /// Results controller manages searched results.
    public var resultsViewController: SYUISearchResultsViewController<SYSearchResult> = SYUISearchResultsTableViewController<SYSearchResult>()
    
    /// Search bar controller manages input field for search.
    public var searchBarController = SYUISearchBarController()
    
    /// Delegate output for search controller.
    public weak var delegate: SYMKSearchViewControllerDelegate?
    
    /// Search find results around this coordinates. If they are not set, user location coordinates are used.
    ///
    /// If search coordinates are not set and user doesn't have valid location, search doesn't return any results.
    public var searchCoordinates: SYGeoCoordinate? {
        didSet {
            model?.coordinates = searchCoordinates
        }
    }
    
    /// Max number of results search returns.
    public var maxResultsCount = SYMKSearchModel.maxResultsDefault {
        didSet {
            model?.maxResultsCount = maxResultsCount
        }
    }
    
    // MARK: - Private properties
    
    private var model: SYMKSearchModel?
    
    // MARK: - Public methods
    
    override func sygicSDKInitialized() {
        model = SYMKSearchModel(maxResultsCount: maxResultsCount, coordinates: searchCoordinates)
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

    /// Prefill search input field and search for results for this text.
    ///
    /// - Parameter text: String for search input field.
    public func prefillSearch(with text: String) {
        searchBarController.prefillSearch(with: text)
        search(for: text)
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
        model?.search(with: query) { [weak self] (results, state) in
            self?.resultsViewController.data = results
        }
    }
    
}

extension SYMKSearchViewController: SYUISearchBarDelegate {
    
    public func searchBar(textDidChange searchedText: String) {
        search(for: searchedText)
    }
    
    public func searchBarDidBeginEditing() { }
    
    public func searchBarDidEndEditing() { }
    
    public func searchBarSearchButtonClicked() {
        delegate?.searchController(self, didSearched: resultsViewController.data)
    }
    
    public func searchBarCancelButtonClicked() {
        delegate?.searchControllerDidCancel(self)
    }
    
}
