import UIKit
import SygicUIKit
import SygicMapsKit

private class CustomColorPallete: SYUIColorPalette {
    var action: UIColor {
        return .red
    }
}

class CustomSkinExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Custom skin"
        
        SYUIColorSchemeManager.shared.currentColorPalette = CustomColorPallete()
        
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
