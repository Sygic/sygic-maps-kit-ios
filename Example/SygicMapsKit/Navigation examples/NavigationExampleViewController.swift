//// NavigationExampleViewController.swift
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


class NavigationExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var routing: SYRouting?
    var routeComputed: ((SYRoute)->())?
    
    deinit {
        routing?.cancelComputing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInitializingActivityIndicator()
        
        routeComputed = { [weak self] (testRoute) in
            let navigationModule = SYMKNavigationViewController(with: testRoute)
            self?.presentModule(navigationModule)
        }
        
        computeRoute()
    }
    
    /// Helper function to quick get SYRoute. (The route can be obtained form SYMKRoutingModule in the future)
    private func computeRoute() {
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] success in
            guard let self = self else { return }
            guard success else {
                let errorAlert = UIAlertController.init(title: "Error init SDK", message: nil, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            let start = SYWaypoint(position: SYGeoCoordinate(latitude: 48.146211, longitude: 17.126587)!, type: .start, name: "StartWP")
            let end = SYWaypoint(position: SYGeoCoordinate(latitude: 48.166338, longitude: 17.150818)!, type: .end, name: "EndWP")
            
            let routing = SYRouting()
            routing.delegate = self
            routing.computeRoute(start, to: end, via: nil, with: nil)
            self.routing = routing
        }
    }
    
    /// Just to see something while SDK is initializing and SYRoute computing
    private func setupInitializingActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
    }
}

extension NavigationExampleViewController: SYRoutingDelegate {
    func routing(_ routing: SYRouting, didComputePrimaryRoute route: SYRoute?) {
        if let route = route {
            routeComputed?(route)
        }
        routing.cancelComputing()
    }
}
