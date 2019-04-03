//// BrowseModuleExampleViewController.swift
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

import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseModuleExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transition demo"
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.delegate = self
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        browseMap.bounceDefaultPoiDetailFirstTime = shouldBouncePoiDetail()
        
        presentModule(browseMap)
    }
    
    private func shouldBouncePoiDetail() -> Bool {
        let firstBouncePlayedKey = "com.sygicMapsKit.firstBounceBrowseMapPoiDetailPlayed"
        if !UserDefaults.standard.bool(forKey: firstBouncePlayedKey) {
            UserDefaults.standard.set(true, forKey: firstBouncePlayedKey)
            return true
        }
        return false
    }
}

extension BrowseModuleExampleViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        let routeComputeModule = SYMKRouteComputeController()
        routeComputeModule.mapState = browseController.mapState.copy() as! SYMKMapState
        routeComputeModule.delegate = self
        
        presentModule(routeComputeModule)
    }
    
}

extension BrowseModuleExampleViewController: SYMKRouteComputeControllerProtocol {
    
    func routeComputeControllerGoBack() {
        dismissModule()
    }
    
}
