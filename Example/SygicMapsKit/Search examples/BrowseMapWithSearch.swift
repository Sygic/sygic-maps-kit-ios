//// BrowseMapWithSearch.swift
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

import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseMapWithSearchViewController: UIViewController, SYMKModulePresenter, SYMKSearchViewControllerDelegate {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        browseMap.setupActionButton(with: nil, icon: SYUIIcon.search) { [unowned self] in
            self.searchButtonTapped()
        }
        
        presentModule(browseMap)
    }
    
    private func searchButtonTapped() {
        let searchModule = SYMKSearchViewController()
        searchModule.delegate = self
        presentModule(searchModule)
    }
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        dismissModule()
        let alert = UIAlertController(title: nil, message: "\(results)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }

}


