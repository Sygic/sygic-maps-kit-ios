
/// Module view controller. Subclass of `UIViewController` that contains Sygic Map object and handle
/// SDK initialization. It contains `SYMKMapState` object that stores map view and state of map.
public class SYMKModuleViewController: UIViewController {
    
    /// State of map in module.
    ///
    /// Pass map state between multiple modules. So you can share state of map and mapView object.
    /// You can pass state by reference or create copy with `SYMKMapState` `copy()` method and
    /// pass new instance. So you just change state of new module.
    public var mapState: SYMKMapState = SYMKMapState()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] success in
            if success {
                self?.sygicSDKInitialized()
            } else {
                self?.sygicSDKFailure()
            }
        }
    }
    
    /// Method called after Sygic SDK is succesfully initialized.
    ///
    /// Override this method in subclass. Use this override like `viewDidLoad`
    /// for module, because `viewDidLoad` is used for SDK initialize.
    internal func sygicSDKInitialized() { }
    
    /// Method called after Sygic SDK initialization fails.
    internal func sygicSDKFailure() { }
    
}
