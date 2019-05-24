//// Skins.swift
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

private class CustomColorPallete: SYUIColorPalette {
    var action: UIColor {
        return .red
    }
}

private class CustomFont: SYUIFontFamily {
    // here you can override your custom fonts to use
    var bold: String { return "Futura-CondensedExtraBold" }
}

class CustomSkinExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Skins Example"
        
        // set color pallete with overrided colors
        SYUIColorSchemeManager.shared.currentColorPalette = CustomColorPallete()
        
        // set font family with your defined font names
        // SYUIFontManager.shared.currentFontFamily = CustomFont()
        
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useRecenterButton = true
        browseMapModule.useZoomControl = true
        browseMapModule.useCompass = true
        browseMapModule.mapSelectionMode = .all
        browseMapModule.customMarkers = customMarkers()
        browseMapModule.userLocationSkin = .pedestrian
        browseMapModule.mapSkin = .night
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
        presentModule(browseMapModule)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SYUIColorSchemeManager.shared.currentColorPalette = SYUIDefaultColorPalette()
        super.viewDidDisappear(animated)
    }
    
    private func customMarkers() -> [SYMapMarker] {
        let pin1 = SYMapMarker(with: SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!), color: .red)
        let pin2 = SYMapMarker(with: SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!), color: .red)
        return [pin1, pin2]
    }
    
}
