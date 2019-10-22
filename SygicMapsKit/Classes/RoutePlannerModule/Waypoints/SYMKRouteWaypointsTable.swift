//// SYMKRouteWaypointsTable.swift
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


public class SYMKRouteWaypointsTable: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SYMKRouteWaypointCell.self, forCellReuseIdentifier: SYMKRouteWaypointCell.cellIdentifier)
        table.estimatedRowHeight = SYMKRouteWaypointCell.height
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView()
        table.isEditing = true
        table.separatorStyle = .none
        return table
    }()
    
    lazy var heightContraint: NSLayoutConstraint = {
        let con = heightAnchor.constraint(equalToConstant: SYMKRouteWaypointCell.height)
        return con
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.coverWholeSuperview()
        heightContraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class SYMKRouteWaypointCell: UITableViewCell {
    
    static let cellIdentifier = "waypointCellIdentifier"
    static let height: CGFloat = 56
    
    public var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .accentSecondary
        return imageView
    }()
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentSecondary
        label.font = SYUIFont.with(.regular, size: SYUIFontSize.headingOld)
        return label
    }()
    
    public var waypointLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentBackground
        label.font = SYUIFont.with(.regular, size: SYUIFontSize.bodyOld)
        return label
    }()
    
    public var deleteButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .plain
        button.iconImage = SYUIIcon.binFilled
        button.tintColor = .error
        return button
    }()
    
    let margin: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = margin
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        waypointLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(waypointLabel)
        waypointLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        waypointLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: -3).isActive = true
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Int {
    func waypointLetter() -> String? {
        let startingValue = Int(("A" as UnicodeScalar).value)
        if let ch = UnicodeScalar(self + startingValue) {
            return "\(Character(ch))"
        }
        return nil
    }
}
