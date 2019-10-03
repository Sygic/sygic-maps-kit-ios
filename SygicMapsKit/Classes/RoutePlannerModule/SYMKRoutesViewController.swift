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
    func routeViewControllerNavigationPressed()
    func routeViewControllerPreviewPressed()
}

public class SYMKRoutesViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var routesView: SYUIBubbleView {
        return view as! SYUIBubbleView
    }
    
    // MARK: - Private properties
    
    public var routes = [SYRoute]() {
        didSet {
            updateViewData()
        }
    }
    public weak var delegate: SYMKRoutesViewControllerDelegate?
    
    public var units: SYUIDistanceUnits = .kilometers
    
    private lazy var navigateButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .primary13
        button.title = LS("routeCompute.action.navigate")
        button.iconImage = SYUIIcon.getDirection
        button.height = SYUIActionButtonSize.infobar.rawValue
        button.isEnabled = routes.count > 0
        button.action = { _ in
            self.delegate?.routeViewControllerNavigationPressed()
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
            self.delegate?.routeViewControllerPreviewPressed()
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
        view = bubbleView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        routesView.addActionButton(previewButton)
        routesView.addActionButton(navigateButton)
        updateViewData()
    }
    
    /// Dismiss poiDetail controller and removes him from parentViewController
    ///
    /// - Parameter completion: completion block
    public func dismissPoiDetail(completion: ((_ finished: Bool)->())?) {
        view.removeFromSuperview()
        removeFromParent()
        completion?(true)
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
