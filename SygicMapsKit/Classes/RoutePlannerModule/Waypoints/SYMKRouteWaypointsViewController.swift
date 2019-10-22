//// SYMKRouteWaypointsViewController.swift
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


public typealias SYMKRouteWaypointsAddBlock = (_ newWaypoint: SYWaypoint)->()

public protocol SYMKRouteWaypointsViewControllerDelegate: class {
    func routeWaypointsController(_ controller: SYMKRouteWaypointsViewController, wantAddWaypoint addWaypointBlock: @escaping SYMKRouteWaypointsAddBlock)
    func routeWaypointsController(_ controller: SYMKRouteWaypointsViewController, didUpdate waypoints: [SYWaypoint])
    func routeWaypointsControllerDidFinish(_ controller: SYMKRouteWaypointsViewController)
}

public class SYMKRouteWaypointsViewController: UIViewController {
    
    //MARK: - Public Properties
    
    public weak var delegate: SYMKRouteWaypointsViewControllerDelegate?
    
    public var waypointsView: SYUIBubbleView {
        return view as! SYUIBubbleView
    }
    
    //MARK: - Private Properties
    
    private lazy var addButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .secondary13
        button.title = LS("com.sygic.addWaypoint.placeholder")
        button.height = SYUIActionButtonSize.infobar.rawValue
        button.action = { [unowned self] _ in
            self.delegate?.routeWaypointsController(self, wantAddWaypoint: { [weak self] (newWaypoint) in
                self?.addWaypoint(newWaypoint)
            })
        }
        return button
    }()
    
    private lazy var doneButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .primary13
        button.title = LS("favorites.button.done")
        button.height = SYUIActionButtonSize.infobar.rawValue
        button.isEnabled = waypoints.count >= 2
        button.action = { [unowned self] _ in
            self.delegate?.routeWaypointsControllerDidFinish(self)
        }
        return button
    }()
    
    private var waypoints: [SYWaypoint] = [] {
        didSet {
            doneButton.isEnabled = waypoints.count >= 2
            delegate?.routeWaypointsController(self, didUpdate: waypoints)
        }
    }
    
    private var modified: Bool = false
    
    private let tableHeader = SYMKRouteWaypointsTable()
    
    //MARK: - Public Methods
    
    public init(with waypoints: [SYWaypoint]) {
        super.init(nibName: nil, bundle: nil)
        self.waypoints = waypoints
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let bubbleView = SYUIBubbleView()
        bubbleView.panGestureRecognizer.isEnabled = false
        bubbleView.tapGestureRecognizer.isEnabled = false
        view = bubbleView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableHeader.tableView.dataSource = self
        tableHeader.tableView.delegate = self
        waypointsView.addHeader(tableHeader)
        waypointsView.addActionButton(addButton)
        waypointsView.addActionButton(doneButton)
        updateTableHeight()
    }
    
    public func addWaypoint(_ newWaypoint: SYWaypoint) {
        waypoints.append(newWaypoint)
        tableHeader.tableView.reloadData()
        updateTableHeight()
        modified = true
    }
    
    //MARK: - Private Methods
    
    private func removeWaypoint(at indexPath: IndexPath, table tableView: UITableView) {
        guard indexPath.row < waypoints.count else { return }
        tableView.beginUpdates()
        waypoints.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        modified = true
    }
    
    private func updateTableHeight() {
        tableHeader.heightContraint.constant = SYMKRouteWaypointCell.height * CGFloat(min(waypoints.count, 8))
    }
}

extension SYMKRouteWaypointsViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypoints.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let waypoint = waypoints[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SYMKRouteWaypointCell.cellIdentifier) as! SYMKRouteWaypointCell
        cell.iconView.image = waypoint.isCurrentLocationWaypoint ? SYUIIcon.locationEmpty : SYUIIcon.pinFull
        cell.waypointLabel.text = waypoint.isCurrentLocationWaypoint ? "" : indexPath.row.waypointLetter()
        cell.titleLabel.text = waypoint.name
        cell.deleteButton.action = { [weak self] _ in
            self?.removeWaypoint(at: indexPath, table: tableView)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        var waypointsCopy = waypoints
        let movedObject = waypointsCopy[sourceIndexPath.row]
        waypointsCopy.remove(at: sourceIndexPath.row)
        waypointsCopy.insert(movedObject, at: destinationIndexPath.row)
        waypoints = waypointsCopy
        modified = true
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
