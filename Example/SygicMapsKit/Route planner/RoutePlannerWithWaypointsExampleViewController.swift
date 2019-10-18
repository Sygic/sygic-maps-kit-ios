//// RoutePlannerWithWaypointsExampleViewController.swift
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

import Foundation
import SygicMaps
import SygicMapsKit


class RoutePlannerWithWaypointsExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    let routePlannerModule = SYMKRoutePlannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let start = SYWaypoint(position: SYGeoCoordinate(latitude: 41.891192, longitude: 12.491788), type: .start, name: "Start waypoint")
        let end = SYWaypoint(position: SYGeoCoordinate(latitude: 41.799047, longitude: 12.590420), type: .end, name: "End waypoint")
        routePlannerModule.waypoints = [start, end]
        routePlannerModule.useOptionsButton = true
        routePlannerModule.useCancelButton = true
        routePlannerModule.delegate = self
        presentModule(routePlannerModule)
    }
}

extension RoutePlannerWithWaypointsExampleViewController: SYMKRoutePlannerControllerDelegate {
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool) {
    }
    
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController) {
    }
}
