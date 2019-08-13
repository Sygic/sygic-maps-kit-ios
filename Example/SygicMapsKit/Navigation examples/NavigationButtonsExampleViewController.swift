//// NavigationButtonsExampleViewController.swift
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


class NavigationButtonsExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    let navigationModule = SYMKNavigationViewController()
    
    var defaultButton: SYUIActionButton?
    
    var superCustomLockButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .secondary
        button.height = 48.0
        button.icon = SYUIIcon.positionLockIos
        button.addTarget(self, action: #selector(customLockButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Switch button", style: .done, target: self, action: #selector(tapped))
        
        defaultButton = navigationModule.leftInfobarButton
        navigationModule.delegate = self
        presentModule(navigationModule)
        
        RoutingHelper.shared.computeRoute(from: SYGeoCoordinate(latitude: 49.211638, longitude: 18.549533)!, to: SYGeoCoordinate(latitude: 48.142441, longitude: 17.143728)!) { [weak self] result in
            switch result {
            case .success(route: let testRoute):
                self?.navigationModule.startNavigation(with: testRoute, preview: true)
            case .error(errorMessage: let message):
                self?.showErrorMessageAlert(message)
            }
        }
    }
    
    @objc private func tapped() {
        guard let navigationModule = presentedModules.first as? SYMKNavigationViewController else { return }
        
        let signpostType = UIAlertController(title: "Left infobar button", message: nil, preferredStyle: .actionSheet)
        signpostType.addAction(UIAlertAction(title: "Default", style: .default, handler: { _ in
            navigationModule.leftInfobarButton = self.defaultButton
        }))
        signpostType.addAction(UIAlertAction(title: "Lock", style: .default, handler: { _ in
            navigationModule.leftInfobarButton = self.superCustomLockButton
        }))
        signpostType.addAction(UIAlertAction(title: "None", style: .default, handler: { _ in
            navigationModule.leftInfobarButton = nil
        }))
        signpostType.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(signpostType, animated: true)
    }
    
    @objc private func customLockButtonPressed(_ button: SYUIActionButton) {
        let isLocked = navigationModule.mapState.cameraMovementMode != .free
        navigationModule.mapState.cameraMovementMode = isLocked ? .free : .followGpsPositionWithAutozoom
        navigationModule.mapState.cameraRotationMode = isLocked ? .free : .vehicle
    }
}

extension NavigationButtonsExampleViewController: SYMKNavigationViewControllerDelegate {
    func navigationController(_ controller: SYMKNavigationViewController, didUpdate mapState: SYMKMapState) {
        if mapState.cameraMovementMode == .free {
            superCustomLockButton.icon = SYUIIcon.positionIos
        } else {
            superCustomLockButton.icon = SYUIIcon.positionLockIos
        }
    }
}
