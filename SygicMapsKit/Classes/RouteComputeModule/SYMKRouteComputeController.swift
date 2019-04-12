//// SYMKRouteComputeController.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps


public protocol SYMKRouteComputeControllerProtocol: class {
    func routeComputeControllerGoBack()
}

public class SYMKRouteComputeController: SYMKModuleViewController {
    
    public var useTraffic = true
    public var computeMultipleRoutes = true
    
    public weak var delegate: SYMKRouteComputeControllerProtocol?
    
    private var mapController: SYMKMapController?
    
    public override func loadView() {
        let routeComputeView = SYMKRouteComputeView()
        routeComputeView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view = routeComputeView
    }
    
    @objc public func backButtonTapped() {
        delegate?.routeComputeControllerGoBack()
    }
    
    override internal func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        SYPositioning.shared().startUpdatingPosition()
        
        setupMapController()
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: mapState)
        mapController.selectionManager = SYMKMapSelectionManager(with: .none)
        (view as! SYMKRouteComputeView).setupMapView(mapController.mapView)
        self.mapController = mapController
    }
    
}
