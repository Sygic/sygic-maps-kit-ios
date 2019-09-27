//// DemoExampleViewController.swift
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

import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class DemoViewController: UIViewController, SYMKModulePresenter {
    var presentedModules = [SYMKModuleViewController]()
    
    lazy var browseModule: SYMKBrowseMapViewController = {
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useZoomControl = true
        browseMap.useRecenterButton = true
        browseMap.showUserLocation = true
        browseMap.mapSelectionMode = .all
        browseMap.delegate = self
        browseMap.setupActionButton(with: nil, icon: SYUIIcon.search) { [unowned self] in
            self.presentModule(self.searchModule)
        }
        return browseMap
    }()
    
    lazy var searchModule: SYMKSearchViewController = {
        let search = SYMKSearchViewController()
        search.delegate = self
        return search
    }()
    
    var placeDetail: SYMKPlaceDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DEMO"
        presentModule(browseModule)
    }
    
    func showPlaceDetail(with data: SYMKPoiData) {
        // MOVE MAP TO PLACE
        browseModule.mapState.cameraMovementMode = .free
        browseModule.mapState.geoCenter = data.location
        
        // PIN
        if let pin = SYMKMapPin(data: data) {
            pin.highlighted = true
            browseModule.customMarkers = [pin.mapMarker]
        }
        
        // CUSTOM PLACE DETAIL WITH NAVIGATION BUTTON
        let placeController = SYMKPlaceDetailViewController(with: data)
        placeController.placeView.addActionButton(placeDetailActionButton(for: data))
        placeController.presentPlaceDetailAsChildViewController(to: browseModule, landscapeLayout: UIApplication.shared.statusBarOrientation.isLandscape, animated: true, completion: nil)
        placeDetail = placeController
    }
    
    func placeDetailActionButton(for data: SYMKPoiData) -> SYUIActionButton {
        let button = SYUIActionButton()
        button.style = .primary13
        button.title = LS("Get direction")
        button.icon = SYUIIcon.directions
        button.height = SYUIActionButtonSize.infobar.height
        button.action = { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.computeRoute(to: data)
            weakSelf.hidePlaceDetail()
        }
        return button
    }
    
    func hidePlaceDetail() {
        placeDetail?.dismissPoiDetail(completion: nil)
        placeDetail = nil
        browseModule.customMarkers = []
    }
    
    func computeRoute(to placeData: SYMKPoiData) {
        guard let myPosition = SYPosition.lastKnownLocation(), let myLocation = myPosition.coordinate else { return }
        let startWP = SYWaypoint(position: myLocation, type: .start, name: "Current location")
        let endWP = SYWaypoint(position: placeData.location, type: .end, name: placeData.name)
        let routePlannerModule = SYMKRoutePlannerController()
        routePlannerModule.mapState = browseModule.mapState
        routePlannerModule.delegate = self
        routePlannerModule.waypoints = [startWP, endWP]
        presentModule(routePlannerModule)
    }
    
    func startNavigation(with route: SYRoute, preview: Bool) {
        let navigationModule = SYMKNavigationViewController(with: route)
        navigationModule.delegate = self
        navigationModule.mapState = browseModule.mapState
        navigationModule.instructionsType = .signpost
        navigationModule.mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        navigationModule.mapState.cameraRotationMode = .vehicle
        navigationModule.mapState.tilt = 60
        navigationModule.preview = preview
        presentModule(navigationModule)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension DemoViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapControllerDidTapOnMap(_ browseController: SYMKBrowseMapViewController, selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool {
        if placeDetail == nil {
            return true
        } else {
            hidePlaceDetail()
            return false
        }
    }
    
    func browseMapControllerShouldAddMarkerOnTap(_ browseController: SYMKBrowseMapViewController, location: SYGeoCoordinate) -> SYMapMarker? {
        return nil
    }
    
    func browseMapControllerShouldPresentDefaultPoiDetail(_ browseController: SYMKBrowseMapViewController) -> Bool {
        return false
    }
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        guard let data = data as? SYMKPoiData else { return }
        showPlaceDetail(with: data)
    }
}

extension DemoViewController: SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        hidePlaceDetail()
        dismissModule()
        
        guard results.count == 1, let result = results.first, let coordinate = result.coordinate else { return }
        if let placeResult = result as? SYMapSearchResultPoi {
            SYPlacesManager.sharedPlaces().loadPlace(placeResult.link) { [weak self] (place, error) in
                guard let place = place else { return }
                self?.showPlaceDetail(with: SYMKPoiData(with: place))
            }
        } else if let mapResult = result as? SYMapSearchResult {
            guard let resultData = SYMKPoiData(with: mapResult) else { return }
            showPlaceDetail(with: resultData)
        } else {
            showPlaceDetail(with: SYMKPoiData(with: coordinate))
        }
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        searchController.prefillSearch(with: "")
        dismissModule()
    }
}

extension DemoViewController: SYMKRoutePlannerControllerDelegate {
    
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool) {
        if presentedModules.last == planner {
            dismissModule()
        }
        startNavigation(with: route, preview: preview)
    }
    
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController) {
        browseModule.mapState.resetMapCenter()
        dismissModule()
    }
}

extension DemoViewController: SYMKNavigationViewControllerDelegate {
    
    func navigationControllerDidStopNavigating(_ controller: SYMKNavigationViewController) {
        if presentedModules.last == controller {
            browseModule.mapState.resetMapCenter()
            dismissModule()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
