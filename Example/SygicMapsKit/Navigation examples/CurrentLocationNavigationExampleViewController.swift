//// CurrentLocationNavigationExampleViewController.swift
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


class CurrentLocationNavigationExampleViewController: UIViewController, SYMKModulePresenter {
    
    var currentLocation: SYGeoCoordinate?
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInitializingActivityIndicator()
        setupLocationManager()
        
        let navigationModule = SYMKNavigationViewController()
        presentModule(navigationModule)
    }
    
    func setupLocationManager() {
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] (success) in
            guard success else {
                let errorAlert = UIAlertController(title: "Error init SDK", message: nil, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            SYPositioning.shared().delegate = self
            SYPositioning.shared().startUpdatingPosition()
        }
    }
    
    func computeRoute(from location: SYGeoCoordinate) {
        RoutingHelper.shared.computeRoute(from: location, to: SYGeoCoordinate(latitude: 41.891192, longitude: 12.491788)!) { [weak self] (testRoute) in
            
            guard let navigationModule = self?.presentedModules.first as? SYMKNavigationViewController else { return }
            navigationModule.startNavigation(with: testRoute)
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

extension CurrentLocationNavigationExampleViewController: SYPositioningDelegate {
    func positioning(_ positioning: SYPositioning, didUpdate position: SYPosition) {
        guard currentLocation == nil, let location = position.coordinate else { return }
        
        currentLocation = location
        computeRoute(from: location)
    }
}
