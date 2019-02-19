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

        title = "Themes Example"
        
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
        browseMapModule.mapSkin = .night
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
        presentModule(browseMapModule)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SYUIColorSchemeManager.shared.currentColorPalette = SYUIDefaultColorPalette()
        super.viewDidDisappear(animated)
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, color: .red)!
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, color: .red)!
        pin2.highlighted = true
        return [pin1, pin2]
    }
    
}
