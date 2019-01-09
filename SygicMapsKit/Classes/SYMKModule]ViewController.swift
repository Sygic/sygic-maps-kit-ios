import SygicMaps


public class SYMKModuleViewController: UIViewController {
    
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
    
    // TODO: Documentation needed [MS-4705]
    internal func sygicSDKInitialized() { }
    
    internal func sygicSDKFailure() { }
    
}
