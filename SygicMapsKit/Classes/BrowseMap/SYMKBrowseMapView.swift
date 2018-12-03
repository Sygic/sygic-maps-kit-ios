import UIKit
import SygicMaps
import SygicUIKit

class SYMKBrowseMapView: UIView {
    
    // MARK: - Public Properties
    
    public var mapView: SYMapView?
    
    // MARK: - Private Properties

    private let sideMargin: CGFloat = 16
    
    private weak var compass: UIView?
    private weak var recenterButton: UIView?
    private weak var zoomControl: UIView?
    
    // MARK: - Public Methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupMapView() {
        mapView = SYMapView(frame: bounds, geoCenter: SYGeoCoordinate(latitude: 48.147, longitude: 17.101878)!, rotation: 0, zoom: 16, tilt: 0)
        guard let mapView = mapView else { return }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        sendSubview(toBack: mapView)
        mapView.coverWholeSuperview()
    }
    
    public func setupCompass(_ compass: UIView) {
        self.compass = compass
        addSubview(compass)
        bringSubview(toFront: compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
        compass.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
    }
    
    public func setupZoomControl(_ zoomControl: UIView) {
        self.zoomControl = zoomControl
        addSubview(zoomControl)
        bringSubview(toFront: zoomControl)
        zoomControl.translatesAutoresizingMaskIntoConstraints = false
        zoomControl.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        if let recenterButton = recenterButton {
            zoomControl.bottomAnchor.constraint(equalTo: recenterButton.topAnchor, constant: -sideMargin).isActive = true
        } else {
            zoomControl.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
        }
    }
    
    public func setupRecenter(_ recenter: UIView) {
        recenterButton = recenter
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
