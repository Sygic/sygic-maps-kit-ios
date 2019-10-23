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
    
    private let timeFormatter: DateFormatter = {
        let timeFormater = DateFormatter()
        timeFormater.timeStyle = .short
        return timeFormater
    }()
    
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
        routesView.contentContainer.removeAll()
        if routes.count > 0 {
            for (i, route) in routes.enumerated() {
                let header = SYUIBubbleHeader()
                header.titleLabel.attributedText = attributedRouteTitle(for: route, index: i, defaultAttributes: [.font: header.titleLabel.font])
                header.descriptionLabel.attributedText = attributedRouteDescription(for: route, defaultAttributes: [.font: header.descriptionLabel.font])
                routesView.addHeader(header)
            }
            navigateButton.isEnabled = routes.count > 0
        } else {
            routesView.addHeader(SYUIBubbleLoadingHeader())
        }
        if let previewIcon = SYUIIcon.play {
            routesView.addContent(with: previewIcon, title: LS("routeActionMain.preview"), subtitle: nil, action: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.routesViewControllerPreviewPressed(weakSelf)
            })
        }
    }
    
    private func attributedRouteTitle(for route: SYRoute, index: Int, defaultAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let titleText = "Route\(index+1) (\(route.formatedDuration()))"
        let attributedDescripton = NSMutableAttributedString()
        attributedDescripton.append(NSAttributedString(string: titleText, attributes: defaultAttributes))
        if let delay = route.formatedTrafficDelay() {
            let trafficString = " \(SYUIIcon.traffic) \(delay)"
            let attributedTraffic = NSAttributedString(string: trafficString, attributes: [.font: SYUIFont.iconFontWith(size: SYUIFontSize.headingOld)!, .foregroundColor: UIColor.error])
            attributedDescripton.append(attributedTraffic)
        }
        return attributedDescripton
    }
    
    private func attributedRouteDescription(for route: SYRoute, defaultAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let routeEta = Date(timeIntervalSinceNow: route.info.durationWithSpeedProfileAndTraffic)
        let text = "\(route.formattedDistance(units)) . \(LS("routeCompute.etaArrival")) \(timeFormatter.string(from: routeEta))"
        let attributedDescripton = NSMutableAttributedString()
        attributedDescripton.append(NSAttributedString(string: text, attributes: defaultAttributes))
        if let avoids = attributedStringFromAvoids(on: route) {
            attributedDescripton.append(NSAttributedString(string: "・", attributes: defaultAttributes))
            attributedDescripton.append(avoids)
        }
        return attributedDescripton
    }
    
    private func attributedStringFromAvoids(on route: SYRoute) -> NSAttributedString? {
        var routeAvoids = Set<SYAvoidType>()
        for transit in route.transitCountries {
            let countryAvoids = route.availableAvoids(inCountry: transit)
            for avoidNumber in countryAvoids {
                guard let avoid = SYAvoidType(rawValue: avoidNumber.intValue) else { continue }
                routeAvoids.insert(avoid)
            }
        }
        let avoidsIcons = routeAvoids.compactMap { $0.icon }
        if !avoidsIcons.isEmpty {
            return NSAttributedString(string: avoidsIcons.compactConcate(), attributes: [.font: SYUIFont.iconFontWith(size: SYUIFontSize.bodyOld)!, .baselineOffset : -2])
        }
        return nil
    }
}

extension SYMKRoutesViewController: SYUIBubbleViewDelegate {
    
    public func bubbleView(_ view: SYUIBubbleView, didScrollHeader pageIndex: Int) {
        currentRouteIndex = pageIndex
    }
}
