import UIKit
import SygicMaps
import SygicUIKit


/// Browse Map Module's view.
class SYMKBrowseMapView: UIView {
    
    // MARK: - Public Properties
    
    /// Map view.
    public private(set) weak var mapView: UIView?
    /// Compass view.
    public private(set) weak var compass: UIView?
    /// Recenter button view.
    public private(set) weak var recenterButton: UIView?
    /// Zoom control view.
    public private(set) weak var zoomControl: UIView?
    
    // MARK: - Private Properties
    
    private let sideMargin: CGFloat = 16
    
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
    
    /// Setup map view on whole scene.
    ///
    /// - Parameter mapView: Map view to set up.
    public func setupMapView(_ mapView: UIView) {
        self.mapView = mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        sendSubview(toBack: mapView)
        mapView.coverWholeSuperview()
    }
    
    /// Setup compass on scene.
    ///
    /// - Parameter compass: Compass to set up.
    public func setupCompass(_ compass: UIView) {
        self.compass = compass
        addSubview(compass)
        bringSubview(toFront: compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
        compass.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
    }
    
    /// Setup zoom control on scene.
    ///
    /// - Parameter zoomControl: Zoom Control to set up.
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
    
    /// Setup recenter button on scene.
    ///
    /// - Parameter recenter: Recenter button to set up.
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
