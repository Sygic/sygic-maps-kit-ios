//// BrowseMapWithSearchResults.swift
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


class BrowseMapWithSearchResults: UIViewController, SYMKModulePresenter, SYMKSearchViewControllerDelegate, SYMKBrowseMapViewControllerDelegate {
    
    var presentedModules = [SYMKModuleViewController]()
    var poiDetail: SYMKPoiDetailViewController?
    var resultsTableView: SYUISearchResultsTableViewController<SYMapSearchResult>?
    var browseMapModule: SYMKBrowseMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMapModule = browseMap
        browseMap.delegate = self
        browseMap.useCompass = true
        browseMap.useRecenterButton = true // FIXME: delete
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        
        presentModule(browseMap)
        
        setupSearchButton(for: browseMap)
    }
    
    private func setupSearchButton(for browseMap: SYMKBrowseMapViewController) {
        let searchButton = SYUIActionButton()
        searchButton.style = .secondary
        searchButton.icon = SYUIIcon.search
        searchButton.accessibilityIdentifier = "Search Button"
        searchButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        browseMap.view.addSubview(searchButton)
        searchButton.trailingAnchor.constraint(equalTo: browseMap.view.safeTrailingAnchor, constant: -16).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: browseMap.view.safeBottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped() {
        let searchModule = SYMKSearchViewController()
        searchModule.delegate = self
        presentModule(searchModule)
    }
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol?) {
        if data == nil {
            browseController.customMarkers = []
            poiDetail?.dismissPoiDetail { _ in
                self.poiDetail = nil
            }
        }
    }
    
    func addPin(on browseMap: SYMKBrowseMapViewController, pin: SYMKMapPin, poiData: SYMKPoiData) {
        browseMap.customMarkers = [pin]
        poiDetail = SYMKPoiDetailViewController(with: poiData)
        poiDetail!.presentPoiDetailAsChildViewController(to: self, completion: nil)
        browseMap.mapState.geoCenter = pin.coordinate
    }
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        dismissModule()
        let mapResults = results.compactMap({ (result) -> SYMapSearchResult? in
            return result as? SYMapSearchResult
        })
        let browseMap = presentedModules[0] as! SYMKBrowseMapViewController
        
        if mapResults.count == 1 {
            let result = mapResults[0]
            
            if let poi = result as? SYMapSearchResultPoi {
                poi.detail { poiDetail in
                    guard let detailedPoi = poiDetail as? SYSearchResultDetailPoi else { return }
                    let poiData = SYMKPoiData(with: detailedPoi)
                    let category = SYMKPoiCategory.with(syPoiCategory: detailedPoi.category)
                    let pin = SYMKMapPin(data: poiData, icon: category.icon, color: category.color, highlighted: true)!
                    self.addPin(on: self.browseMapModule!, pin: pin, poiData: poiData)
                }
                return
            }
            
            if let resultCoordinate = result.coordinate {
                let poiData = SYMKPoiData(with: resultCoordinate)
                let pin = SYMKMapPin(data: poiData, highlighted: true)!
                addPin(on: browseMap, pin: pin, poiData: poiData)
            } else {
                // TODO: [] bug - search filtruje resulty, ktore nemaju coordinaty (teda kategorie a groupy)
//                result.detail { resultDetail in
//                    if let categoryDetail = resultDetail as? SYSearchResultDetailPoiCategory {
//                        var pins = [SYMKMapPin]()
//                        categoryDetail.pois.forEach { detailPoi in
//                            guard let coordinate = detailPoi.coordinate else { return }
//                            let category = SYMKPoiCategory.with(syPoiCategory: detailPoi.category)
//                            guard let pin = SYMKMapPin(coordinate: coordinate, icon: category.icon, color: category.color, highlighted: false) else { return }
//                            pins.append(pin)
//                            browseMap.customMarkers = pins
//                        }
//                    } else if let groupDetail = resultDetail as? SYSearchResultDetailPoiCategoryGroup {
//                        var pins = [SYMKMapPin]()
//                        groupDetail.pois.forEach { detailPoi in
//                            guard let coordinate = detailPoi.coordinate else { return }
//                            let group = SYMKPoiGroup.with(syPoiGroup: detailPoi.group)
//                            guard let pin = SYMKMapPin(coordinate: coordinate, icon: group.icon, color: group.color, highlighted: false) else { return }
//                            pins.append(pin)
//                            browseMap.customMarkers = pins
//                        }
//                    }
//                }
            }
            
        } else {
            let bottomSheet = SYUIBottomSheetView()
            resultsTableView = SYUISearchResultsTableViewController<SYMapSearchResult>()
            resultsTableView?.data = mapResults
            resultsTableView?.selectionBlock = { [weak self] result in
                if let coordinate = result.coordinate {
                    let poiData = SYMKPoiData(with: coordinate)
                    let pin = SYMKMapPin(data: poiData, highlighted: true)!
                    self?.addPin(on: browseMap, pin: pin, poiData: poiData)
                }
                bottomSheet.animateOut {
                    self?.resultsTableView = nil
                    bottomSheet.removeFromSuperview()
                }
            }
            bottomSheet.addSubview(resultsTableView!.view)
            browseMap.view.addSubview(bottomSheet)
            bottomSheet.minimizedHeight = 200
            bottomSheet.animateIn(nil)
        }
        
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }

}
