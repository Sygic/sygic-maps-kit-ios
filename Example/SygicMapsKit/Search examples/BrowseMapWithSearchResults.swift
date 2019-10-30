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
            guard let coord1 = marker.coordinate, let coord2 = markers[1].coordinate, coord1.isValid(), coord2.isValid() else { return }
            var boundingBox = SYGeoBoundingBox(bottomLeft: SYGeoCoordinate(latitude: min(coord1.latitude, coord2.latitude),
                                                                           longitude: min(coord1.longitude, coord2.longitude)),
                                               topRight: SYGeoCoordinate(latitude: max(coord1.latitude, coord2.latitude),
                                                                         longitude: max(coord1.longitude, coord2.longitude)))
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
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchGeocodingResult]) {
        dismissModule()
        
        if results.count == 1, let result = results.first {
            if let placeResult = result as? SYSearchPlaceResult {
                addMarker(from: placeResult)
            } else if result.location != nil {
                addMarker(from: result)
            }
        } else {
            addMultipleMarkers(from: results)
        }
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }
    
    private func addMarker(from placeResult: SYSearchPlaceResult) {
        SYPlacesManager.sharedPlaces().loadPlace(placeResult.link) { (place, error) in
            guard let place = place else { return }
            let poiData = SYMKPlaceData(with: place)
            let category = SYMKPlaceCategory.with(sdkPlaceCategory: place.category)
            let pin = SYMapMarker(with: poiData, icon: category.icon, color: category.color)
            self.addMarkers(markers: [pin])
        }
    }
    
    private func addMarker(from result: SYSearchGeocodingResult) {
        guard let placeData = SYMKPlaceData(with: result) else { return }
        let pin = SYMapMarker(with: placeData)
        addMarkers(markers: [pin])
    }
    
    private func addMultipleMarkers(from results: [SYSearchGeocodingResult]) {
        var markers: [SYMapMarker] = []
        for result in results {
            guard let placeData = SYMKPlaceData(with: result) else { continue }
            let marker: SYMapMarker
            if let place = result as? SYSearchPlaceResult, let category = place.categoryTags.first {
                let category = SYMKPlaceCategory.with(sdkPlaceCategory: category)
                marker = SYMapMarker(with: placeData, icon: category.icon, color: category.color)
            } else {
                marker = SYMapMarker(with: placeData)
            }
            markers.append(marker)
        }
        addMarkers(markers: markers)
    }
}
