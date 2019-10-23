//// DoubleMapViewController.swift
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
import SygicMaps
import SygicMapsKit

class DoubleMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Double map sample"
        view.backgroundColor = .background
        
        let mapModule1 = browseMap()
        let mapModule2 = browseMapWithAllControls()
        
        addChild(mapModule1)
        addChild(mapModule2)
        
        mapModule1.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapModule1.view)
        mapModule1.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapModule1.view.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        mapModule1.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapModule2.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapModule2.view)
        mapModule2.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapModule2.view.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        mapModule2.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapModule1.view.trailingAnchor.constraint(equalTo: mapModule2.view.leadingAnchor, constant: -8).isActive = true
        
        mapModule1.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
    }

    private func browseMap() -> SYMKBrowseMapViewController {
        let browseMapVC = SYMKBrowseMapViewController()
        browseMapVC.showUserLocation = true
        browseMapVC.mapSelectionMode = .none
        browseMapVC.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)
        browseMapVC.mapState.tilt = 70
        browseMapVC.mapState.zoom = 20
        browseMapVC.mapState.cameraRotationMode = .vehicle
        browseMapVC.mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        return browseMapVC
    }
    
    private func browseMapWithAllControls() -> SYMKBrowseMapViewController {
        let browseMapVC = SYMKBrowseMapViewController()
        browseMapVC.showUserLocation = true
        browseMapVC.useZoomControl = true
        browseMapVC.useRecenterButton = true
        browseMapVC.mapSelectionMode = .all
        browseMapVC.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)
        browseMapVC.mapState.zoom = 16
        return browseMapVC
    }
}
