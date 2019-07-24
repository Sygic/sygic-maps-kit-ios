//// NavigationSignpostsExampleViewController.swift
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
import SygicMapsKit
import SygicMaps
import SygicUIKit


class NavigationSignpostsExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInitializingActivityIndicator()
    
        RoutingHelper.shared.computeRoute(from: SYGeoCoordinate(latitude: 48.146815, longitude: 17.142426)!, to: SYGeoCoordinate(latitude: 48.142441, longitude: 17.143728)!) { [weak self] (result) in
            
            switch result {
            case .success(route: let testRoute):
                let navigationModule = SYMKNavigationViewController(with: testRoute)
                self?.presentModule(navigationModule)
                navigationModule.startNavigation(with: testRoute, preview: true)
                self?.setupSignpostsSelectionButton()
            case .error(errorMessage: let message):
                self?.showErrorMessage(message)
            }
        }
    }
    
    private func setupSignpostsSelectionButton() {
        let signpostTypeSelectButton = SYUIActionButton()
        signpostTypeSelectButton.style = .secondary
        signpostTypeSelectButton.title = "Instructions"
        signpostTypeSelectButton.accessibilityIdentifier = "Instructions"
        signpostTypeSelectButton.height = 44
        signpostTypeSelectButton.titleSize = 15
        signpostTypeSelectButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        signpostTypeSelectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signpostTypeSelectButton)
        signpostTypeSelectButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        signpostTypeSelectButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped() {
        guard let navigationModule = presentedModules.first as? SYMKNavigationViewController else { return }
        
        let signpostType = UIAlertController(title: "Instructions type", message: nil, preferredStyle: .actionSheet)
        signpostType.addAction(UIAlertAction(title: "Direction", style: .default, handler: { _ in
            navigationModule.instructionsType = .direction
        }))
        signpostType.addAction(UIAlertAction(title: "Signpost", style: .default, handler: { _ in
            navigationModule.instructionsType = .signpost
        }))
        signpostType.addAction(UIAlertAction(title: "None", style: .default, handler: { _ in
            navigationModule.instructionsType = .none
        }))
        present(signpostType, animated: true)
    }
    
    /// Just to see something while SDK is initializing and SYRoute computing
    private func setupInitializingActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
    }
    
    private func showErrorMessage(_ message: String) {
        let errorAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    
}
