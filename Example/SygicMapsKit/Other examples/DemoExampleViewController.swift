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
    
    var placeDetailViewController: SYMKPoiDetailViewController?
    var placeDetailDataSource: NaviPlaceDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        placeDetailDataSource = NaviPlaceDataSource(with: data)
        placeDetailDataSource?.action = { [weak self] in
            self?.navigate(to: data)
            self?.hidePlaceDetail()
        }
        placeDetailDataSource?.preview = { [weak self] in
            self?.navigate(to: data, preview: true)
            self?.hidePlaceDetail()
        }
        placeDetailViewController = SYMKPoiDetailViewController(with: data)
        placeDetailViewController?.presentPoiDetailAsChildViewController(to: browseModule, completion: nil)
        placeDetailViewController?.dataSource = placeDetailDataSource
        placeDetailViewController?.reloadData()
    }
    
    func hidePlaceDetail() {
        placeDetailViewController?.dismissPoiDetail(completion: nil)
        placeDetailViewController = nil
        browseModule.customMarkers = []
    }
    
    func navigate(to placeData: SYMKPoiData, preview: Bool = false) {
        guard let myPosition = SYPosition.lastKnownLocation(), let myLocation = myPosition.coordinate else { return }
        RoutingHelper.shared.computeRoute(from: myLocation, to: placeData.location) { [weak self] (result) in
            switch result {
            case .success(route: let route):
                self?.switchToNavigation(with: route, preview: preview)
            case .error(errorMessage: let errorMessage):
                self?.showErrorMessageAlert(errorMessage)
            }
        }
    }
    
    func switchToNavigation(with route: SYRoute, preview: Bool) {
        let navigationModule = SYMKNavigationViewController(with: route)
        navigationModule.delegate = self
        navigationModule.mapState = browseModule.mapState
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
        if placeDetailViewController == nil {
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
        guard results.count == 1, let result = results.first, let coordinate = result.coordinate else { return }
        if let placeResult = result as? SYMapSearchResultPoi {
            SYPlacesManager.sharedPlaces().loadPlace(placeResult.link) { [weak self] (place, error) in
                guard let place = place else { return }
                self?.showPlaceDetail(with: SYMKPoiData(with: place))
            }
        } else {
            showPlaceDetail(with: SYMKPoiData(with: coordinate))
        }
        dismissModule()
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        searchController.prefillSearch(with: "")
        dismissModule()
    }
}

extension DemoViewController: SYMKNavigationViewControllerDelegate {
    func navigationControllerDidStopNavigating(_ controller: SYMKNavigationViewController) {
        if presentedModules.last == controller {
            browseModule.mapState = controller.mapState
            dismissModule()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

class NaviPlaceDataSource: SYUIPoiDetailDataSource {
    private var model: SYMKPoiDetailModel
    private let topOffset: CGFloat = 100
    
    public var action: (()->())?
    public var preview: (()->())?
    
    private lazy var navigationButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.title = "Navigate"
        button.icon = SYUIIcon.directions
        button.height = 44
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var previewButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.title = "Preview"
        button.style = .secondary
        button.icon = SYUIIcon.vehicle
        button.height = 44
        button.addTarget(self, action: #selector(performPreview), for: .touchUpInside)
        return button
    }()
    
    init(with model: SYMKPoiDetailModel) {
        self.model = model
    }
    
    @objc func performAction() {
        action?()
    }
    
    @objc func performPreview() {
        preview?()
    }
    
    public var poiDetailMaxTopOffset: CGFloat {
        return topOffset
    }
    
    public var poiDetailTitle: String {
        return model.poiDetailTitle
    }
    
    public var poiDetailSubtitle: String? {
        return model.poiDetailSubtitle
    }
    
    public var poiDetailNumberOfActionButtons: Int {
        return 2
    }
    
    public func poiDetailActionButton(for index: Int) -> SYUIActionButton {
        if index == 1 {
            return previewButton
        }
        return navigationButton
    }
    
    public func poiDetailNumberOfRows(in section: SYUIPoiDetailSectionType) -> Int {
        switch section {
        case .actions:
            return 1
        case .contactInfo:
            return model.poiDetailContacts.count
        default:
            return 0
        }
    }
    
    public func poiDetailCellData(for indexPath: IndexPath) -> SYUIPoiDetailCellDataSource {
        guard let section = SYUIPoiDetailSectionType(rawValue: indexPath.section) else { return SYUIPoiDetailCellData(title: "") }
        switch section {
        case .actions:
            return SYUIPoiDetailCellData(title: "GPS", subtitle: model.location.string, icon: SYUIIcon.pinPlace, stringToCopy: model.location.string)
        case .contactInfo:
            let contact = model.poiDetailContacts[indexPath.row]
            return SYUIPoiDetailCellData(title: contact.title, subtitle: contact.value, icon: contact.icon)
        default:
            return SYUIPoiDetailCellData(title: "")
        }
    }
}
