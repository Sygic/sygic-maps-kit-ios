//// RoutePlannerExampleViewController.swift
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


class RoutePlannerExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    let routePlannerModule = SYMKRoutePlannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        routePlannerModule.delegate = self
        presentModule(routePlannerModule)
    }
}

extension RoutePlannerExampleViewController: SYMKRoutePlannerControllerDelegate {
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool) {}
    
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController) {}
    
    func routePlanner(_ planner: SYMKRoutePlannerController, wantsAddNewWaypoint newWaypointBlock: @escaping SYMKRouteWaypointsAddBlock) {
        showSearchModuleForRoutePlannerWaypointsEditor(with: newWaypointBlock)
    }
}

extension SYMKModulePresenter {
    public func showSearchModuleForRoutePlannerWaypointsEditor(with block: @escaping SYMKRouteWaypointsAddBlock) {
        let search = SYMKSearchViewController()
        search.multipleResultsSelection = false
        search.searchBlock = { [weak self] results in
            self?.dismissModule()
            let result = results.first { $0.location != nil }
            guard let foundedResult = result else { return }
            block(SYWaypoint(position: foundedResult.location!, type: .end, name: foundedResult.detailCellTitle?.string))
        }
        search.cancelBlock = { [weak self] in
            self?.dismissModule()
        }
        presentModule(search)
    }
}
