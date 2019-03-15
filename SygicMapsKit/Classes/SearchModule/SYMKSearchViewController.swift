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
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [Any])
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController)
}

public class SYMKSearchViewController: SYMKModuleViewController {
    
    // MARK: - Public properties
    
    public var resultsViewController: SYUISearchResultsViewController<SYSearchResult> = SYUISearchResultsTableViewController<SYSearchResult>()
    public var searchBarController = SYUISearchBarController()
    public weak var delegate: SYMKSearchViewControllerDelegate?
    
    // MARK: - Public methods
    
    override func sygicSDKInitialized() {
        searchBarController.delegate = self
        resultsViewController.interactionBlock = { [weak self] in
            _ = self?.searchBarController.resignFirstResponder()
        }
    }
    
    override func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }

    /// input
    public func prefillSearch(with text: String) {
        searchBarController.prefillSearch(with: text)
    }
    
    // TODO: implement input coordinates based on model logic
    //       MS-5189
    public func mapCoordinates(coordinates: SYGeoCoordinate) { }
    
    public override func loadView() {
        let searchView = SYMKSearchView()
        view = searchView
        
        addChildViewController(searchBarController)
        searchView.setupSearchBarView(searchBarController.view)
        
        addChildViewController(resultsViewController)
        searchView.setupResultsView(resultsViewController.view)
    }
    
    // MARK: - Private methods
}

extension SYMKSearchViewController: SYUISearchBarDelegate {
    
    public func search(textDidChange searchedText: String) {
        // model.searchedText = searchedText
    }
    
    public func searchDidBeginEditing() { }
    
    public func searchDidEndEditing() { }
    
    public func searchSearchButtonClicked() { }
    
    public func searchCancelButtonClicked() {
        delegate?.searchControllerDidCancel(self)
    }
    
}
