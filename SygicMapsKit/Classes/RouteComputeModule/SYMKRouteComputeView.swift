import SygicUIKit
import UIKit


class SYMKRouteComputeView: UIView {
    
    private let sideMargin: CGFloat = 16
    
    public private(set) weak var mapView: UIView?
    
    public var nextBrowseMapButton = SYUIActionButton(frame: .zero)
    public var backButton = SYUIActionButton(frame: .zero)
    
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
    
    public func setupBackButton() {
        backButton.title = "Back"
        backButton.style = .primary
        backButton.isEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        backButton.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
        backButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        backButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
    }
    
    private func setupUI() {
        setupBackButton()
        backgroundColor = UIColor.white
    }
    
}
