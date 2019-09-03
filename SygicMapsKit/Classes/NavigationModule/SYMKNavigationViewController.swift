//// SYMKNavigationViewController.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SygicMaps
import SygicUIKit


/// Navigation module output protocol. Methods are optional with empty default implementation.
public protocol SYMKNavigationViewControllerDelegate: class {
    
    /// Called after map state is changed
    ///
    /// - Parameter controller: Navigation module controller
    /// - Parameter mapState: Map state with current map properties
    func navigationController(_ controller: SYMKNavigationViewController, didUpdate mapState: SYMKMapState)
    
    /// Called after navigation controller starts navigating.
    ///
    /// - Parameter controller: Navigation module controller
    /// - Parameter mapRoute: SYMapObject representing SYRoute on map. Added to mapView automatically when navigation starts.
    func navigationController(_ controller: SYMKNavigationViewController, didStartNavigatingWith mapRoute: SYMapRoute)
    
    /// Called after navigaton is stopped.
    ///
    /// - Parameter controller: Navigation module controller
    func navigationControllerDidStopNavigating(_ controller: SYMKNavigationViewController)
    
    /// Called when better route is found while navigation is running
    ///
    /// - Parameter controller: Navigation module controller
    /// - Parameter route: SYRoute with additional information about route properties
    func navigationController(_ controller: SYMKNavigationViewController, didFindBetterRoute route: SYAlternativeRoute)
    
    /// Called after waypoint on route is passed
    ///
    /// - Parameter controller: Navigation module controller
    /// - Parameter didPassWaypoint: Passed waypoint
    /// - Parameter index: Index of waypont within route.waypoints (Start and Destination is not counded as waypoints)
    func navigationController(_ controller: SYMKNavigationViewController, didPassWaypoint: SYWaypoint, at index: UInt)
    
    /// Called after navigaton reach finish position.
    ///
    /// - Parameter controller: Navigation module controller
    func navigationControllerDidReachFinish(_ controller: SYMKNavigationViewController)
}

public extension SYMKNavigationViewControllerDelegate {
    func navigationController(_ controller: SYMKNavigationViewController, didUpdate mapState: SYMKMapState) {}
    func navigationController(_ controller: SYMKNavigationViewController, didStartNavigatingWith mapRoute: SYMapRoute) {}
    func navigationControllerDidStopNavigating(_ controller: SYMKNavigationViewController) {}
    func navigationController(_ controller: SYMKNavigationViewController, didFindBetterRoute route: SYAlternativeRoute) {}
    func navigationController(_ controller: SYMKNavigationViewController, didPassWaypoint: SYWaypoint, at index: UInt) {}
    func navigationControllerDidReachFinish(_ controller: SYMKNavigationViewController) {}
}

/// Type of view with navigation instructions.
///
/// - direction: Instructions using arrow direction with distance and road street names.
/// - signpost: Extended direction instructions with signposts.
/// - none: No instruction view.
public enum SYMKInstructionType {
    case direction
    case signpost
    case none
}

/// Navigation module
///
/// Navigation can be started with only one primary route. Creating multiple navigation module cannot start navigating on multiple routes.
public class SYMKNavigationViewController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    /// Delegate output for browse map controller.
    public weak var delegate: SYMKNavigationViewControllerDelegate?
    
    /// Navigation route
    public private(set) var route: SYRoute? {
        didSet {
            guard route != oldValue, SYMKSdkManager.shared.isSdkInitialized else { return }
            if let newRoute = route {
                mapRoute = SYMapRoute(route: newRoute, type: .primary)
                SYNavigation.shared().start(with: route)
            } else {
                mapRoute = nil
                if SYNavigation.shared().isNavigating() {
                    SYNavigation.shared().stop()
                }
            }
        }
    }
    
    /// Indicates if navigation should simulate device position through route. Default: false
    public var preview: Bool = false {
        didSet {
            guard preview != oldValue, SYMKSdkManager.shared.isSdkInitialized else { return }
            if preview {
                startPreview()
            } else {
                stopPreview()
            }
        }
    }
    
    /// Enables lane assistance.
    public var useLaneAssist: Bool = true
    
    /// Enables current speed.
    public var useCurrentSpeed = true
    
    /// Enables speed limit. If both current speed and speed limit are enabled, speed limit is showed on top of current speed.
    public var useSpeedLimit = true

    /// Enables infobar functionality
    public var useInfobar: Bool = true
    
    /// Button that appears inside infobarView. Default button locks map position on user location
    public var leftInfobarButton: SYUIActionButton? {
        didSet {
            infobarController?.infobarView.leftButton = leftInfobarButton
        }
    }
    
    /// Button that appears inside infobarView. Default button cancels navigation
    public var rightInfobarButton: SYUIActionButton? {
        didSet {
            infobarController?.infobarView.rightButton = rightInfobarButton
        }
    }
    
    /// Type of view with navigation instructions.
    public var instructionsType: SYMKInstructionType = .direction {
        didSet {
            switch instructionsType {
            case .direction:
                instructionsController = SYMKDirectionController()
            case .signpost:
                instructionsController = SYMKSignpostController()
            case .none:
                instructionsController = nil
            }
        }
    }
    
    /// Distance units. Default value is metric units.
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            instructionsController?.units = units
            infobarController?.units = units
            speedController?.units = units
        }
    }
    
    /// Setting enables playing instruction voices and other navigation alert sounds
    public var audioEnabled: Bool = true {
        didSet {
            guard !audioEnabled, SYMKSdkManager.shared.isSdkInitialized else { return }
            SYAudioManager.shared().stopOutputAndClearQueue()
        }
    }
    
    // MARK: - Private Properties
    
    private var mapRoute: SYMapRoute? {
        didSet {
            guard let navigationView = view as? SYMKNavigationView, let map = navigationView.mapView as? SYMapView else { return }
            if let oldRoute = oldValue {
                map.remove(oldRoute)
            }
            if let newRoute = mapRoute {
                map.add(newRoute)
            }
        }
    }
    
    private var mapController: SYMKMapController?
    
    private var infobarController: SYMKInfobarController?
    private var speedController: SYMKSpeedController?
    private let routePreviewController = SYMKRoutePreviewController()
    private let laneAssistController = SYMKLaneAssistController()

    private var instructionsController: SYMKDirectionController? = SYMKDirectionController() {
        didSet {
            guard let navigationView = view as? SYMKNavigationView, let instructionsController = instructionsController else {
                (view as? SYMKNavigationView)?.setupInstructionView(nil)
                (view as? SYMKNavigationView)?.setupLaneAssistView(nil)
                return
            }
            instructionsController.units = units
            navigationView.setupInstructionView(instructionsController.view)
            navigationView.setupLaneAssistView(laneAssistController.view)
        }
    }
    
    private let leftInfobarButtonDefaultIdentifier = "NavigationMapInfobarLeftActionButton"
    
    // MARK: - Public Methods
    
    public init(with route: SYRoute? = nil) {
        self.route = route
        if let newRoute = route {
            mapRoute = SYMapRoute(route: newRoute, type: .primary)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        mapState = SYMKMapState.navigationMapState()
        
        routePreviewController.previewDelegate = self
        
        let lockButton = SYUIActionButton()
        lockButton.style = .primary13
        lockButton.icon = SYUIIcon.positionIos
        lockButton.height = 48
        lockButton.accessibilityIdentifier = leftInfobarButtonDefaultIdentifier
        lockButton.addTarget(self, action: #selector(leftInfobarButtonPressed), for: .touchUpInside)
        leftInfobarButton = lockButton
        
        let cancelRouteButton = SYUIActionButton()
        cancelRouteButton.style = .error13
        cancelRouteButton.icon = SYUIIcon.close
        cancelRouteButton.height = 48
        cancelRouteButton.addTarget(self, action: #selector(stopNavigation), for: .touchUpInside)
        rightInfobarButton = cancelRouteButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopNavigation()
    }
    
    public override func loadView() {
        let navigationView = SYMKNavigationView()
        if let instructionsController = instructionsController {
            navigationView.setupInstructionView(instructionsController.view)
        }
        if useLaneAssist {
            navigationView.setupLaneAssistView(laneAssistController.view)
        }
        if useInfobar {
            setupInfobarController()
            if let infobarController = infobarController {
                navigationView.setupInfobarView(infobarController.infobarView)
            }
        }
        if useCurrentSpeed || useSpeedLimit {
            speedController = SYMKSpeedController(currentSpeed: useCurrentSpeed, speedLimit: useSpeedLimit)
            if let speedController = speedController, let speedControlsView = speedController.view {
                navigationView.setupSpeedControlView(speedControlsView)
            }
        }
        view = navigationView
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if let map = mapState.map {
            (view as! SYMKNavigationView).setupMapView(map)
            map.renderEnabled = true
            map.setup(with: mapState)
        }
        super.viewDidAppear(animated)
    }
    
    public override func sygicSDKInitialized() {
        triggerUserLocation(true)
        setupMapController()
        if useCurrentSpeed {
            speedController?.setupSpeedUpdater()
        }
        mapState.updateLandscapeMapCenter(SYUIDeviceOrientationUtils.isLandscapeStatusBar())
        SYNavigation.shared().delegate = self
        SYNavigation.shared().audioFeedbackDelegate = self
        
        guard let route = route, let mapRoute = mapRoute, let map = mapState.map else { return }
        map.remove(mapRoute)
        map.add(mapRoute)
        SYNavigation.shared().start(with: route)
        delegate?.navigationController(self, didStartNavigatingWith: mapRoute)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mapState.updateLandscapeMapCenter(SYUIDeviceOrientationUtils.isLandscapeStatusBar())
    }
    
    /// Start navigation
    /// - Parameter route: route
    /// - Parameter preview: if true, navigation will simulate device position through route (default: false)
    public func startNavigation(with route: SYRoute, preview: Bool = false) {
        self.route = route
        self.preview = preview
        guard let mapRoute = mapRoute else { return }
        delegate?.navigationController(self, didStartNavigatingWith: mapRoute)
    }
    
    /// Stops current navigation and removes route
    @objc public func stopNavigation() {
        guard route != nil, SYMKSdkManager.shared.isSdkInitialized, SYNavigation.shared().isNavigating() else { return }
        preview = false
        route = nil
        delegate?.navigationControllerDidStopNavigating(self)
    }
    
    // MARK: - Private Methods
    
    private func setupMapController() {
        mapController = SYMKMapController(with: mapState, mapFrame: view.bounds)
        mapController?.delegate = self
        guard let navigationView = view as? SYMKNavigationView, let map = mapController?.mapView else { return }
        navigationView.setupMapView(map)
    }
    
    private func setupInfobarController() {
        infobarController = SYMKInfobarController()
        infobarController?.units = units
        infobarController?.infobarView.leftButton = leftInfobarButton
        infobarController?.infobarView.rightButton = rightInfobarButton
    }
    
    private func startPreview() {
        guard let route = route else { return }
        routePreviewController.startPreview(route)
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.setupRoutePreviewView(routePreviewController.view)
    }
    
    private func stopPreview() {
        routePreviewController.stopPreview()
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.routePreviewView?.removeFromSuperview()
    }
    
    @objc private func leftInfobarButtonPressed() {
        if mapState.cameraMovementMode == .free {
            lockPosition()
        } else {
            showContextMenu()
        }
    }
    
    private func lockPosition() {
        mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        mapState.cameraRotationMode = .vehicle
    }
    
    private func showContextMenu() {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.popoverPresentationController?.sourceView = leftInfobarButton
        
        let audioSetting = audioEnabled ? LS("off") : LS("on")
        let soundAction = UIAlertAction(title: "\(LS("Sounds")) \(audioSetting.uppercased())", style: .default) { (_) in
            self.audioEnabled = !self.audioEnabled
        }
        menu.addAction(soundAction)
        menu.addAction(UIAlertAction(title: LS("Cancel"), style: .cancel, handler: nil))
        
        present(menu, animated: true, completion: nil)
    }
}

extension SYMKNavigationViewController: SYNavigationDelegate {
    
    public func navigation(_ navigation: SYNavigation, didPassWaypointWith index: UInt) {
        guard let wps = navigation.waypoints else { return }
        let waypointPassed = wps[Int(index)]
        delegate?.navigationController(self, didPassWaypoint: waypointPassed, at: index)
    }
    
    public func navigation(_ navigation: SYNavigation, didFindBetterRoute alterRoute: SYAlternativeRoute?) {
        guard let alterRoute = alterRoute else { return }
        delegate?.navigationController(self, didFindBetterRoute: alterRoute)
    }
    
    public func navigationManagerDidReachFinish(_ navigation: SYNavigation) {
        delegate?.navigationControllerDidReachFinish(self)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate positionInfo: SYPositionInfo?) {
        guard let info = positionInfo else { return }
        infobarController?.updatePositionInfo(info)
        infobarController?.updateRouteProgress(navigation.getRouteProgress())
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate limit: SYSpeedLimit?) {
        if useSpeedLimit {
            speedController?.update(with: limit)
        }
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateSignpost signpostInfo: [SYSignpost]?) {
        guard let signposts = signpostInfo, let signpostController = instructionsController as? SYMKSignpostController else { return }
        signpostController.update(with: signposts)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateDirection instruction: SYInstruction?) {
        guard let instruction = instruction, let instructionsController = instructionsController else { return }
        instructionsController.update(with: instruction)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate lanesInfo: SYLanesInformation?) {
        guard useLaneAssist else { return }
        if let signpostInstructions = instructionsController as? SYMKSignpostController {
            signpostInstructions.update(with: lanesInfo)
        } else {
            laneAssistController.update(with: lanesInfo)
        }
    }

}

extension SYMKNavigationViewController: SYMKRoutePreviewDelegate {
    public func routePreviewDidStop(_ controller: SYMKRoutePreviewController) {
        preview = false
    }
}

extension SYMKNavigationViewController: SYMKMapControllerDelegate {
    public func mapController(_ controller: SYMKMapController, didUpdate mapState: SYMKMapState) {
        delegate?.navigationController(self, didUpdate: mapState)
        
        guard let defaultButton = leftInfobarButton, defaultButton.accessibilityIdentifier == leftInfobarButtonDefaultIdentifier else { return }
        let unlocked = mapState.cameraMovementMode == .free
        defaultButton.icon = unlocked ? SYUIIcon.positionIos : SYUIIcon.contextMenuIos
    }
}

extension SYMKNavigationViewController: SYNavigationAudioFeedbackDelegate {
    public func navigation(_ navigation: SYNavigation, shouldPlayWarningAudioFeedback warning: SYWarning) -> Bool {
        return audioEnabled
    }
    
    public func navigation(_ navigation: SYNavigation, shouldPlayTrafficAudioFeedback traffic: SYTrafficInfo) -> Bool {
        return audioEnabled
    }
    
    public func navigation(_ navigation: SYNavigation, shouldPlaySpeedLimitAudioFeedback speedLimit: SYSpeedLimit) -> Bool {
        return audioEnabled
    }
    
    public func navigation(_ navigation: SYNavigation, shouldPlayBetterRouteAudioFeedback route: SYAlternativeRoute) -> Bool {
        return audioEnabled
    }
    
    public func navigation(_ navigation: SYNavigation, shouldPlayInstructionAudioFeedback instruction: SYInstruction) -> Bool {
        return audioEnabled
    }
}
