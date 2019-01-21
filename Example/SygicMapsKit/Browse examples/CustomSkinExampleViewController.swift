import UIKit
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

        title = "Custom skin"
        
        // set color pallete with overrided colors
        SYUIColorSchemeManager.shared.currentColorPalette = CustomColorPallete()
        
        // set font family with your defined font names
//        SYUIFontManager.shared.currentFontFamily = CustomFont()
        
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useRecenterButton = true
        browseMapModule.useZoomControl = true
        browseMapModule.useCompass = true
        browseMapModule.mapSelectionMode = .all
        presentModule(browseMapModule)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SYUIColorSchemeManager.shared.currentColorPalette = SYUIDefaultColorPalette()
        super.viewDidDisappear(animated)
    }
    
}
