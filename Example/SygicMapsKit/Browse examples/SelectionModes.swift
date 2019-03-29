//// SelectionModes.swift
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


class BrowseMapSelectionModesExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var browseMap: SYMKBrowseMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selection Modes Example"
        
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useZoomControl = true
        browseMapModule.useRecenterButton = true
        browseMapModule.mapSelectionMode = .all
        browseMapModule.customMarkers = customMarkers()
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
        browseMap = browseMapModule
        
        presentModule(browseMapModule)
        
        setupModesSelectionButton()
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SYUIIcon.apple, color: .gray)!
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SYUIIcon.sygic, color: .red)!
        return [pin1, pin2]
    }
    
    private func setupModesSelectionButton() {
        let modeSelectButton = SYUIActionButton()
        modeSelectButton.style = .secondary
        modeSelectButton.title = "Selection mode"
        modeSelectButton.accessibilityIdentifier = "Selection mode"
        modeSelectButton.height = 44
        modeSelectButton.titleSize = 15
        modeSelectButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        modeSelectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeSelectButton)
        modeSelectButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        modeSelectButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 16).isActive = true
    }
    
    @objc private func tapped() {
        let modes = UIAlertController(title: "Selection Modes", message: nil, preferredStyle: .actionSheet)
        modes.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .all
        }))
        modes.addAction(UIAlertAction(title: "Markers only", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .markers
        }))
        modes.addAction(UIAlertAction(title: "None", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .none
        }))
        present(modes, animated: true)
    }
    
}
