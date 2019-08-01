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
    let navigationModule = SYMKNavigationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Instruction Type", style: .done, target: self, action: #selector(tapped))
        
        presentModule(navigationModule)
        
        RoutingHelper.shared.computeRoute(from: SYGeoCoordinate(latitude: 49.211638, longitude: 18.549533)!, to: SYGeoCoordinate(latitude: 48.142441, longitude: 17.143728)!) { [weak self] result in
            switch result {
            case .success(route: let testRoute):
                self?.navigationModule.startNavigation(with: testRoute, preview: true)
            case .error(errorMessage: let message):
                self?.showErrorMessage(message)
            }
        }
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
        signpostType.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(signpostType, animated: true)
    }

    private func showErrorMessage(_ message: String) {
        let errorAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    
}
