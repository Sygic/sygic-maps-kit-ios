//// Markers.swift
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

class CustomMarkersExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Custom Markers Example"

        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useRecenterButton = true
        browseMapModule.useZoomControl = true
        browseMapModule.useCompass = true
        browseMapModule.mapSelectionMode = .markers
        browseMapModule.customMarkers = customMarkers()
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!
        browseMapModule.mapState.zoom = 16
    
        presentModule(browseMapModule)
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = pinWithEverything()
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SYUIIcon.android, color: .green)!
        let pin3 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SYUIIcon.sygic, color: .red)!
        return [pin1, pin2, pin3]
    }
    
    private func pinWithEverything() -> SYMKMapPin {
        var data = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!)
        data.name = "Super custom POI"
        data.street = "Mlynske Nivy"
        data.houseNumber = "16"
        data.city = "Bratislava"
        data.postal = "831 09"
        data.website = "www.sygic.com"
        
        let marker = SYMKMapPin(coordinate: data.coordinate, icon: SYUIIcon.apple, color: .gray, highlighted: false)!
        marker.data = data
        return marker
    }
}
