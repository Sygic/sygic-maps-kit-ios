//// SYMKRouteOptionsViewController.swift
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

import UIKit
import SygicMaps
import SygicUIKit


public class SYMKRouteOptionsViewController: UITableViewController {
    
    private var options = SYRoutingOptions()
    
    private var allAvodsList: [SYAvoidType] = [.toll, .ferries, .motorway, .specialArea, .unpavedRoads]
    
    required public init(with options: SYRoutingOptions?) {
        super.init(nibName: nil, bundle: nil)
        if let existingOptions = options {
            self.options = existingOptions
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = LS("routeCompute.options.title")
//        view.backgroundColor = .accentBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        
        tableView.register(SYMKAvoidTableCell.self, forCellReuseIdentifier: SYMKAvoidTableCell.identifier)
    }
    
    @objc private func doneButtonPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: TableView delegate + dataSource
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAvodsList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let avoid = allAvodsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SYMKAvoidTableCell.identifier) as! SYMKAvoidTableCell
        cell.textLabel?.text = avoid.cellTitle
        return cell
    }
}

private class SYMKAvoidTableCell: UITableViewCell {
    static let identifier = "avoidCellIdentifier"
    
    private let switcher = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switcher)
        switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SYAvoidType {
    var cellTitle: String {
        switch self {
        case .ferries:
            return LS("avoid.ferries")
        case .motorway:
            return LS("avoid.highways")
        case .toll:
            return LS("avoid.tollroads")
        case .specialArea:
            return LS("avoid.specialArea")
        case .unpavedRoads:
            return LS("avoid.unpaved")
        default:
            return ""
        }
    }
}
