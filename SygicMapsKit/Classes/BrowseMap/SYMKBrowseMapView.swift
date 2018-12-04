import UIKit
import SygicMaps
import SygicUIKit

class SYMKBrowseMapView: UIView {
    private let sideMargin: CGFloat = 16
    
    public private(set) weak var mapView: UIView?
    public private(set) weak var compass: UIView?
    public private(set) weak var recenterButton: UIView?
    public private(set) weak var zoomControl: UIView?
    
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
    
    public func setupMapView(_ mapView: UIView) {
        self.mapView = mapView
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
