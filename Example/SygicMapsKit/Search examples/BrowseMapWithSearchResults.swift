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


class BrowseMapWithSearchResults: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var poiDetail: SYMKPoiDetailViewController?
    var resultsTableViewController: SYUISearchResultsTableViewController<SYMapSearchResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.delegate = self
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

    func addPin(on browseMap: SYMKBrowseMapViewController, pin: SYMKMapPin, poiData: SYMKPoiData) {
        browseMap.customMarkers = [pin]
        poiDetail = SYMKPoiDetailViewController(with: poiData)
        poiDetail!.defaultMinimizedHeight = 300
        poiDetail!.presentPoiDetailAsChildViewController(to: self, completion: nil)
        browseMap.mapState.geoCenter = pin.coordinate
    }
    
}

extension BrowseMapWithSearchResults: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol?) {
        if data == nil {
            browseController.customMarkers = []
            resultsTableViewController?.view.removeFromSuperview()
            poiDetail?.dismissPoiDetail { _ in
                self.poiDetail = nil
            }
        }
    }
    
}

extension BrowseMapWithSearchResults: SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        dismissModule()
        let mapResults = results.compactMap({ result -> SYMapSearchResult? in
            return result as? SYMapSearchResult
        })
        let browseMap = presentedModules[0] as! SYMKBrowseMapViewController
        
        if mapResults.count == 1 {
            let result = mapResults[0]
            
            if let poi = result as? SYMapSearchResultPoi {
                addPoiWithAdditionalInformationToMap(poi: poi, browseMap: browseMap)
                return
            }
            
            if result.coordinate != nil {
                addSearchResultToMap(result: result, browseMap: browseMap)
            } else {
               resultSheetWithPoisFromCategoryOrGroup(result: result)
            }
        } else {
            resultSheetWithSearchResults(results: mapResults, browseMap: browseMap)
        }
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }
    
    private func addPoiWithAdditionalInformationToMap(poi: SYMapSearchResultPoi, browseMap: SYMKBrowseMapViewController) {
        poi.detail { poiDetail in
            guard let detailedPoi = poiDetail as? SYSearchResultDetailPoi else { return }
            let poiData = SYMKPoiData(with: detailedPoi)
            let category = SYMKPoiCategory.with(syPoiCategory: detailedPoi.category)
            let pin = SYMKMapPin(data: poiData, icon: category.icon, color: category.color, highlighted: true)!
            self.addPin(on: browseMap, pin: pin, poiData: poiData)
        }
    }
    
    private func addSearchResultToMap(result: SYMapSearchResult, browseMap: SYMKBrowseMapViewController) {
        guard let resultCoordinate = result.coordinate else { return }
        var poiData = SYMKPoiData(with: resultCoordinate)
        poiData.street = result.resultLabels.street?.value
        poiData.city = result.resultLabels.city?.value
        poiData.postal = result.resultLabels.postal?.value
        poiData.houseNumber = result.resultLabels.leftNumber?.value ?? result.resultLabels.rightNumber?.value
        let pin = SYMKMapPin(data: poiData, highlighted: true)!
        addPin(on: browseMap, pin: pin, poiData: poiData)
    }
    
    private func resultSheetWithSearchResults(results: [SYMapSearchResult], browseMap: SYMKBrowseMapViewController) {
        resultsTableViewController = SYUISearchResultsTableViewController<SYMapSearchResult>()
        resultsTableViewController?.data = results
        resultsTableViewController?.selectionBlock = { [weak self] result in
            if let coordinate = result.coordinate {
                let poiData = SYMKPoiData(with: coordinate)
                let pin = SYMKMapPin(data: poiData, highlighted: true)!
                self?.addPin(on: browseMap, pin: pin, poiData: poiData)
            }
        }
        view.addSubview(resultsTableViewController!.view)
        resultsTableViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        resultsTableViewController!.view.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        resultsTableViewController!.view.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        resultsTableViewController!.view.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        resultsTableViewController!.view.safeTopAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
    }
    
    private func resultSheetWithPoisFromCategoryOrGroup(result: SYMapSearchResult) {
        // TODO: [MS-5629] bug - search filtruje resulty, ktore nemaju coordinaty (teda kategorie a groupy)
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
    
}
