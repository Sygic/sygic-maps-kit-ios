//// SYMKRoutePreviewController.swift
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

import SygicUIKit
import SygicMaps


/// Route preview controller delegate provides events of starting and stopping preview.
/// All delegated methods are optional with empty default implementation.
public protocol SYMKRoutePreviewDelegate: class {
    /// Called when preview starts
    /// - Parameter controller: preview controller
    func routePreviewDidStart(_ controller: SYMKRoutePreviewController)
    /// Called when preview stops
    /// - Parameter controller: preview controller
    func routePreviewDidStop(_ controller: SYMKRoutePreviewController)
}

public extension SYMKRoutePreviewDelegate  {
    func routePreviewDidStart(_ controller: SYMKRoutePreviewController) {}
    func routePreviewDidStop(_ controller: SYMKRoutePreviewController) {}
}

/// Route preview controller. Provides basic logic and control buttons for route preview simulation.
public class SYMKRoutePreviewController {
    
    // MARK: - Public Properties
    
    public let view = SYMKRoutePreviewView()
    
    weak var previewDelegate: SYMKRoutePreviewDelegate?
    
    // MARK: - Private Properties
    
    private var simulator: SYRoutePositionSimulator?
    private var speed: CGFloat = 1
    private var speedText: String { "\(Int(speed))X" }
    
    // MARK: - Public Methods
    
    public init() {
        view.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        view.speedButton.addTarget(self, action: #selector(speedButtonPressed), for: .touchUpInside)
        view.stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
    }
    
    /// Starts route preview. Creates route position simulator to simulate movement through received route.
    /// - Parameter route: simulated route
    public func startPreview(_ route: SYRoute) {
        guard let simulator = SYRoutePositionSimulator(route: route) else { return }
        self.simulator = simulator
        
        SYPositioning.shared().dataSource = simulator
        simulator.start()
        
        speed = simulator.speedMultiplier
        view.playButton.setImage(SYUIIcon.pause, for: .normal)
        view.speedButton.setTitle(speedText, for: .normal)
        
        previewDelegate?.routePreviewDidStart(self)
    }
    
    /// Stops route preview. Destroys all position simulators and restores default GPS position provider.
    public func stopPreview() {
        guard let simulator = SYPositioning.shared().dataSource as? SYRoutePositionSimulator else { return }
        simulator.stop()
        SYPositioning.shared().dataSource = nil
        previewDelegate?.routePreviewDidStop(self)
    }
    
    @objc private func playButtonPressed() {
        guard let simulator = simulator else { return }
        if simulator.isPaused {
            simulator.start()
            view.playButton.setImage(SYUIIcon.pause, for: .normal)
        } else {
            simulator.pause()
            view.playButton.setImage(SYUIIcon.play, for: .normal)
        }
    }
    
    @objc private func speedButtonPressed() {
        speed = speed == 16 ? 1 : speed*2
        view.speedButton.setTitle(speedText, for: .normal)
        simulator?.speedMultiplier = speed
    }
    
    @objc private func stopButtonPressed() {
        stopPreview()
    }
}
