//// SYMKRoutesViewController.swift
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

import Foundation
import SygicUIKit
import SygicMaps


public protocol SYMKRoutesViewControllerDelegate: class {
    func routesViewControllerNavigationPressed(_ controller: SYMKRoutesViewController)
    func routesViewControllerPreviewPressed(_ controller: SYMKRoutesViewController)
    func routesViewController(_ controller: SYMKRoutesViewController, switchRoute selectedRoute: SYRoute)
}

public class SYMKRoutesViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var routesView: SYUIBubbleView {
        return view as! SYUIBubbleView
    }
    
    public var routes = [SYRoute]() {
        didSet {
            updateViewData()
        }
    }
    public weak var delegate: SYMKRoutesViewControllerDelegate?
    
    public var units: SYUIDistanceUnits = .kilometers
    
    // MARK: - Private properties
    
    private var currentRouteIndex: Int = 0 {
        didSet {
            guard currentRouteIndex != oldValue, routes.count > 0, currentRouteIndex <= routes.count-1 else { return }
            let route = routes[currentRouteIndex]
            delegate?.routesViewController(self, switchRoute: route)
        }
    }
    
    private lazy var navigateButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .primary13
        button.title = LS("routeCompute.action.navigate")
        button.iconImage = SYUIIcon.getDirection
        button.height = SYUIActionButtonSize.infobar.rawValue
        button.isEnabled = routes.count > 0
        button.action = { _ in
            self.delegate?.routesViewControllerNavigationPressed(self)
        }
        return button
    }()
    
    private lazy var previewButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .secondary13
        button.title = LS("routeCompute.action.demonstrate")
        button.iconImage = SYUIIcon.play
        button.height = SYUIActionButtonSize.infobar.rawValue
        button.isEnabled = routes.count > 0
        button.action = { _ in
            self.delegate?.routesViewControllerPreviewPressed(self)
        }
        return button
    }()
    
    // MARK: - Public methods
    
    /// Default initializer with data model structure
    /// - Parameter dataModel: place data
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let bubbleView = SYUIBubbleView()
        bubbleView.delegate = self
        view = bubbleView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        routesView.addActionButton(previewButton)
        routesView.addActionButton(navigateButton)
        updateViewData()
    }
    
    public func switchCurrentRoute(_ route: SYRoute) {
        let index = routes.index(of: route)
        guard let pageIndex = index else { return }
        routesView.updateHeaderCurrentPage(pageIndex)
    }
    
    // MARK: - Private methods
    
    private func updateViewData() {
        routesView.headerStackView.removeAll()
        if routes.count > 0 {
            for (i, route) in routes.enumerated() {
                routesView.addHeader(with: "Route\(i+1) (\(route.formatedDuration()))", "\(route.formattedDistance(units)) . Arrival . traffic . options")
            }
            navigateButton.isEnabled = routes.count > 0
            previewButton.isEnabled = routes.count > 0
        } else {
            routesView.addHeader(SYUIBubbleLoadingHeader())
        }
    }
}

extension SYMKRoutesViewController: SYUIBubbleViewDelegate {
    
    public func bubbleView(_ view: SYUIBubbleView, didScrollHeader pageIndex: Int) {
        currentRouteIndex = pageIndex
    }
}
