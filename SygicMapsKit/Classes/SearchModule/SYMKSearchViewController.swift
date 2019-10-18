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
    
    
    /// Delegate event for error state handling
    ///
    /// - Parameters:
    ///   - searchController: Search module controller.
    ///   - searchState: state to handle
    /// - Returns: String message to display for received search state. Return nil if you don't what to display any message.
    func searchController(_ searchController: SYMKSearchViewController, willShowMessageFor searchError: Error) -> String?
}

public extension SYMKSearchViewControllerDelegate {
    func searchController(_ searchController: SYMKSearchViewController, willShowMessageFor searchError: Error) -> String? {
        return searchError.searchErrorMessage()
    }
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
    
    /// Block called after search controller has searched and selected results
    public var searchBlock: ((_ results: [SYSearchResult])->())?
    
    /// Block called after search has canceled
    public var cancelBlock: (()->())?
    
    /// Search find results around this location. If it is not set, user location is used.
    ///
    /// If search location is not set and user doesn't have valid location, search engine try to search whole world for most relevant results.
    public var searchLocation: SYGeoCoordinate? {
        didSet {
            model?.location = searchLocation
        }
    }
    
    /// Max number of results search returns.
    public var maxResultsCount = SYMKSearchModel.maxResultsDefault {
        didSet {
            model?.maxResultsCount = maxResultsCount
        }
    }
    
    /// Allows multiple results to be returned by `delegate` or `searchBlock`
    public var multipleResultsSelection: Bool = true
    
    // MARK: - Private properties
    
    private var model: SYMKSearchModel?
    
    // MARK: - Public methods
    
    override func sygicSDKInitialized() {
        super.sygicSDKInitialized()
        model = SYMKSearchModel(maxResultsCount: maxResultsCount, location: searchLocation)
        searchBarController.delegate = self
        if !searchBarController.searchText.isEmpty {
            search(for: searchBarController.searchText)
        }
        resultsViewController.interactionBlock = { [weak self] in
            _ = self?.searchBarController.resignFirstResponder()
        }
        resultsViewController.selectionBlock = { [weak self] searchResult in
            guard let strongSelf = self else { return }
            let results = [searchResult]
            strongSelf.delegate?.searchController(strongSelf, didSearched: results)
            strongSelf.searchBlock?(results)
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
        guard let model = model else {
            return
        }
        
        searchBarController.showLoadingIndicator(true)
        
        model.search(with: query) { [weak self] (results, state) in
            self?.resultsViewController.data = results
            self?.resultsViewController.showErrorMessage(self?.errorMessage(for: results, state))
            self?.searchBarController.showLoadingIndicator(false)
        }
    }
    
    private func errorMessage(for results: [SYSearchResult], _ error: Error?) -> String? {
        guard results.count == 0 else { return nil }
        let error = error as NSError?
        if (error == nil || error!.code == NSRequestResultErrorSuccess) && !searchBarController.searchText.isEmpty {
            return LS("No results found")
        } else {
            return error?.searchErrorMessage()
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
        guard multipleResultsSelection else { return }
        let results = resultsViewController.data
        delegate?.searchController(self, didSearched: results)
        searchBlock?(results)
    }
    
    public func searchBarCancelButtonClicked() {
        delegate?.searchControllerDidCancel(self)
        cancelBlock?()
    }
}
