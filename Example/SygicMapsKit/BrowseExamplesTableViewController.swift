//// BrowseExamplesTableViewController.swift
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
import SygicMapsKit


struct ModuleData {
    let title: String
    let subtitle: String
    let image: String
}

class BrowseExamplesTableViewController: UITableViewController {
    
    let modulesData = [
        ModuleData(title: "Browse Map - Default", subtitle: "Browse Map module with no configuration", image: "preview-browsemap-default"),
        ModuleData(title: "Browse Map - Full", subtitle: "Browse Map module with full configuration", image: "preview-browsemap-full"),
        ModuleData(title: "Browse Map - Tap handling", subtitle: "Browse Map module with own tap handling", image: "preview-browsemap-data"),
        ModuleData(title: "Browse Map - Custom Annotation View", subtitle: "Browes Map module with custom view for map points", image: "preview-browsemap-annotation"),
        ModuleData(title: "Browse Map - Skins", subtitle: "Browse Map module with custom skins", image: "preview-browsemap-skins"),
        ModuleData(title: "Browse Map - Markers", subtitle: "Browse Map module with own custom map markers", image: "preview-browsemap-markers"),
        ModuleData(title: "Browse Map - Selection Modes", subtitle: "Browse Map module with all available selection modes", image: "preview-browsemap-selectionmodes"),
        ModuleData(title: "Browse Map - Car/Pedestrian", subtitle: "Switching between multiple map skins", image: "preview-browsemap-pedestrian")
    ]
    
    private let cellHeight: CGFloat = 330
    private let reuseIdentifier = String(describing: ModuleExampleTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse Map Examples"
        tableView.accessibilityLabel = "tableView.browseSamples"
        tableView.register(UINib(nibName: "ModuleExampleTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ModuleExampleTableViewCell
        let data = modulesData[indexPath.row]
        cell.title = data.title
        cell.subtitle = data.subtitle
        cell.imageName = data.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(SYMKBrowseMapViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(browseMapWithAllControls(), animated: true)
        case 2:
            navigationController?.pushViewController(CustomDataHandlingViewController(), animated: true)
        case 3:
            navigationController?.pushViewController(CustomMarkerInfoExampleViewController(), animated: true)
        case 4:
            navigationController?.pushViewController(CustomSkinExampleViewController(), animated: true)
        case 5:
            navigationController?.pushViewController(CustomMarkersExampleViewController(), animated: true)
        case 6:
            navigationController?.pushViewController(BrowseMapSelectionModesExampleViewController(), animated: true)
        case 7:
            navigationController?.pushViewController(BrowseMapPedestrianExampleViewController(), animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    private func browseMapWithAllControls() -> SYMKBrowseMapViewController {
        let browseMapVC = SYMKBrowseMapViewController()
        browseMapVC.showUserLocation = true
        browseMapVC.useCompass = true
        browseMapVC.useZoomControl = true
        browseMapVC.useRecenterButton = true
        browseMapVC.mapSelectionMode = .all
        browseMapVC.bounceDefaultPoiDetailFirstTime = true
        browseMapVC.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)
        browseMapVC.mapState.zoom = 16
        return browseMapVC
    }

}
