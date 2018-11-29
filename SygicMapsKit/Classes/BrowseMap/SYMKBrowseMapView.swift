import UIKit
import SygicMaps
import SygicUIKit

class SYMKBrowseMapView: UIView {
    public var mapView: SYMapView?

    private let sideMargin: CGFloat = 16
    
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
        mapView = SYMapView(frame: bounds, geoCenter: SYGeoCoordinate(latitude: 48.147, longitude: 17.101878)!, rotation: 0, zoom: 16, tilt: 0)
        guard let mapView = mapView else { return }
        addSubview(mapView)
        sendSubview(toBack: mapView)
    }
    
    public func setupCompass(_ compass: SYUICompass) {
        addSubview(compass)
        bringSubview(toFront: compass)
        compass.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
        compass.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
    }
    
    public func setupRecenter(_ recenter: SYUIActionButton) {
        addSubview(recenter)
        bringSubview(toFront: recenter)
        recenter.translatesAutoresizingMaskIntoConstraints = false
        recenter.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        recenter.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = UIColor.gray
    }
}
