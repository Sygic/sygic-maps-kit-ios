import UIKit
import SygicMaps
import SygicUIKit

class SYMKBrowserMapView: UIView {
    
    var mapView: SYMapView?
    let compass = SYUICompass()
    let recenter = SYUIActionButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func setupMapView() {
        mapView = SYMapView()
        guard let mapView = mapView else { return }
        mapView.frame = bounds
        mapView.geoCenter = SYGeoCoordinate(latitude: 48.147, longitude: 17.101878)! //todo: set some default
        addSubview(mapView)
        sendSubview(toBack: mapView)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = UIColor.gray
        setupMapControls()
    }
    
    private func setupMapControls() {
        setupCompass()
        setupRecenter()
    }
    
    private func setupCompass() {
        addSubview(compass)
        bringSubview(toFront: compass)
        compass.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -16).isActive = true
        compass.topAnchor.constraint(equalTo: safeTopAnchor, constant: 16).isActive = true
    }
    
    private func setupRecenter() {
        addSubview(recenter)
        bringSubview(toFront: recenter)
        recenter.translatesAutoresizingMaskIntoConstraints = false
        recenter.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 32).isActive = true
        recenter.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -16).isActive = true
    }
}
