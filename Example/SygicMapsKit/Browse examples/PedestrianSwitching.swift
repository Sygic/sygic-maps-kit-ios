//// PedestrianSwitching.swift
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
import SygicMaps
import SygicUIKit
import SygicMapsKit


class BrowseMapPedestrianExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var browseMap: SYMKBrowseMapViewController?
    var pedestrianButton: SYUIActionButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selection Modes Example"
        
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useZoomControl = true
        browseMapModule.useRecenterButton = true
        browseMapModule.useCompass = true
        browseMapModule.mapSelectionMode = .all
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
        browseMap = browseMapModule
        
        presentModule(browseMapModule)
        
        setupPedestrianSelectionButton()
    }
    
    private func setupPedestrianSelectionButton() {
        let modeSelectButton = SYUIActionButton()
        modeSelectButton.icon = SYUIIcon.walk
        modeSelectButton.accessibilityIdentifier = "Selection mode"
        modeSelectButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        pedestrianButton = modeSelectButton
        
        modeSelectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeSelectButton)
        modeSelectButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        modeSelectButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped() {
        guard let browseModule = browseMap else { return }
        let isPedestrian = browseModule.userLocationSkin == .pedestrian
        if isPedestrian {
            browseModule.userLocationSkin = .car
            pedestrianButton?.icon = SYUIIcon.walk
        } else {
            browseModule.userLocationSkin = .pedestrian
            pedestrianButton?.icon = SYUIIcon.vehicle
        }
    }
    
}
