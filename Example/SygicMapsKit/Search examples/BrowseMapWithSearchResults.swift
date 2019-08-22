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
        if let browseMap = presentedModules.first as? SYMKBrowseMapViewController {
            searchModule.searchLocation = browseMap.mapState.geoCenter
        }
        searchModule.delegate = self
        presentModule(searchModule)
    }

    func addMarkers(markers: [SYMapMarker]) {
        guard let browseMap = presentedModules.first as? SYMKBrowseMapViewController else { return }
        browseMap.customMarkers = markers
        guard let marker = markers.first else { return }
        if markers.count == 1 {
            browseMap.mapState.geoCenter = marker.coordinate!
            browseMap.mapState.zoom = 14
        } else if markers.count > 1 {
            var boundingBox = SYGeoBoundingBox(bottomLeft: marker.coordinate!, topRight: markers[1].coordinate!)
            for mark in markers {
                if let biggerBox = boundingBox.union(with: SYGeoBoundingBox(bottomLeft: mark.coordinate!, topRight: mark.coordinate!)) {
                    boundingBox = biggerBox
                }
            }
            browseMap.mapState.setMapBoundingBox(boundingBox, edgeInsets: UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1), duration: 1)
        }
    }
    
}

extension BrowseMapWithSearchResults: SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        dismissModule()
        let mapResults = results.compactMap({ result -> SYMapSearchResult? in
            return result as? SYMapSearchResult
        })
        
        if mapResults.count == 1, let result = mapResults.first {
            if let poiResult = result as? SYMapSearchResultPoi {
                addMarker(from: poiResult)
            } else if result.coordinate != nil {
                addMarker(from: result)
            } else {
               resultSheetWithPoisFromCategoryOrGroup(result: result)
            }
        } else {
            addMultipleMarkers(from: mapResults)
        }
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }
    
    private func addMarker(from poiResult: SYMapSearchResultPoi) {
        poiResult.detail { resultDetail in
            guard let poiDetail = resultDetail as? SYSearchResultDetailPlace else { return }
            let poiData = SYMKPoiData(with: poiDetail)
            let category = SYMKPlaceCategory.with(sdkPlaceCategory: poiDetail.place.category)
            let pin = SYMapMarker(with: poiData, icon: category.icon, color: category.color)
            self.addMarkers(markers: [pin])
        }
    }
    
    private func addMarker(from result: SYMapSearchResult) {
        guard let placeData = SYMKPoiData(with: result) else { return }
        let pin = SYMapMarker(with: placeData)
        addMarkers(markers: [pin])
    }
    
    private func addMultipleMarkers(from results: [SYMapSearchResult]) {
        var markers: [SYMapMarker] = []
        for result in results {
            guard let poiData = SYMKPoiData(with: result) else { continue }
            let marker: SYMapMarker
            if let poiResult = result as? SYMapSearchResultPoi {
                let category = SYMKPlaceCategory.with(sdkPlaceCategory: poiResult.category)
                marker = SYMapMarker(with: poiData, icon: category.icon, color: category.color)
            } else {
                marker = SYMapMarker(with: poiData)
            }
            markers.append(marker)
        }
        addMarkers(markers: markers)
    }
    
    private func resultSheetWithPoisFromCategoryOrGroup(result: SYMapSearchResult) {
        // TODO: [MS-5629] bug - search filtruje resulty, ktore nemaju coordinaty (teda kategorie a groupy)
        //                result.detail { resultDetail in
        //                    if let categoryDetail = resultDetail as? SYSearchResultDetailPlaceCategory {
        //                        var pins = [SYMKMapPin]()
        //                        categoryDetail.pois.forEach { detailPoi in
        //                            guard let coordinate = detailPoi.coordinate else { return }
        //                            let category = SYMKPlaceCategory.with(syPoiCategory: detailPoi.category)
        //                            guard let pin = SYMKMapPin(coordinate: coordinate, icon: category.icon, color: category.color, highlighted: false) else { return }
        //                            pins.append(pin)
        //                            browseMap.customMarkers = pins
        //                        }
        //                    } else if let groupDetail = resultDetail as? SYSearchResultDetailPlaceCategoryGroup {
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
