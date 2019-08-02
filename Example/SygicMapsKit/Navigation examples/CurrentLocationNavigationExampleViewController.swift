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
        setupLocationManager()
        
        let navigationModule = SYMKNavigationViewController()
        presentModule(navigationModule)
    }
    
    func setupLocationManager() {
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] (success) in
            guard success else {
                self?.showErrorMessageAlert("Error init SDK")
                return
            }
            
            SYPositioning.shared().delegate = self
            SYPositioning.shared().startUpdatingPosition()
        }
    }
    
    func computeRoute(from location: SYGeoCoordinate) {
        RoutingHelper.shared.computeRoute(from: location, to: SYGeoCoordinate(latitude: 41.8899, longitude: 12.49489)!) { [weak self] (result) in
            
            guard let navigationModule = self?.presentedModules.first as? SYMKNavigationViewController else { return }
            
            switch result {
            case .success(route: let testRoute):
                navigationModule.startNavigation(with: testRoute)
            case .error(errorMessage: let message):
                self?.showErrorMessageAlert(message)
            }
        }
    }

    
}

extension CurrentLocationNavigationExampleViewController: SYPositioningDelegate {
    func positioning(_ positioning: SYPositioning, didUpdate position: SYPosition) {
        guard currentLocation == nil, let location = position.coordinate else { return }
        
        currentLocation = location
        computeRoute(from: location)
    }
}

extension UIViewController {
    func showErrorMessageAlert(_ message: String) {
        let errorAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
}
