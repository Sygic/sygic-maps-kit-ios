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


public protocol SYMKRouteOptionsViewControllerDelegate: class {
    func routeOptionsController(_ controller: SYMKRouteOptionsViewController, didUpdate options: SYRoutingOptions)
}


public class SYMKRouteOptionsViewController: UITableViewController {
    
    public weak var delegate: SYMKRouteOptionsViewControllerDelegate?
    
    private var options = SYRoutingOptions()
    
    private var transitCountries = [String]()
    private var avoidedCountries = [String]()
    private var availableAvoidsPerCountry = [String:Set<NSNumber>]()
    
    private var allAvodsList: [SYAvoidType] = [.toll, .ferries, .motorway, .specialArea, .unpavedRoads]
    
    private var modified: Bool = false
    
    required public init(with options: SYRoutingOptions?, currentRoute: SYRoute?) {
        super.init(nibName: nil, bundle: nil)
        if let existingOptions = options {
            self.options = existingOptions
        }
        if let route = currentRoute {
            let avoidCountries = route.transitCountries
            self.transitCountries.append(contentsOf: avoidCountries)
            for country in avoidCountries {
                availableAvoidsPerCountry[country] = route.availableAvoids(inCountry: country)
            }
        }
        if let countryAvoids = options?.countryAvoids {
            let wholeCountryAvoid = NSNumber(value: SYAvoidType.country.rawValue)
            for item in countryAvoids {
                let country = item.key
                if item.value.contains(wholeCountryAvoid) {
                    avoidedCountries.append(country)
                }
                var allAvailableAvoidsPerCountry: Set<NSNumber> = availableAvoidsPerCountry[country] ?? Set()
                if let route = currentRoute {
                    allAvailableAvoidsPerCountry = allAvailableAvoidsPerCountry.union(route.availableAvoids(inCountry: country))
                }
                if allAvailableAvoidsPerCountry.isEmpty {
                    availableAvoidsPerCountry[country] = nil
                } else {
                    availableAvoidsPerCountry[country] = allAvailableAvoidsPerCountry
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = LS("routeCompute.options.title")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        
        tableView.register(SYMKRouteOptionsCountryHeader.self, forHeaderFooterViewReuseIdentifier: SYMKRouteOptionsCountryHeader.identifier)
        tableView.register(SYMKAvoidTableCell.self, forCellReuseIdentifier: SYMKAvoidTableCell.identifier)
        tableView.estimatedSectionHeaderHeight = SYUIActionButtonSize.infobar.rawValue
        tableView.tableFooterView = UIView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        if modified {
            delegate?.routeOptionsController(self, didUpdate: options)
        }
        super.viewWillDisappear(animated)
    }
    
    @objc private func doneButtonPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: TableView delegate + dataSource
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + transitCountries.count + avoidedCountries.count
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SYMKRouteOptionsCountryHeader.identifier) as? SYMKRouteOptionsCountryHeader else { return nil }
        if section == 0 {
            header.countryLabel.text = "Global avoids"
            header.avoidButton.isHidden = true
        }else if section <= transitCountries.count {
            let country = transitCountries[section-1]
            var canBeAvoided = false//section != 1 && section < transitCountries.count
            if let avoids = availableAvoidsPerCountry[country] {
                canBeAvoided = avoids.contains(NSNumber(value: SYAvoidType.country.rawValue))
            }
            header.countryLabel.text = LS("country.\(country.uppercased())")
            header.avoidButton.isHidden = !canBeAvoided
            header.avoidButton.title = LS("routeCompute.options.AvoidCountry")
            header.avoidButton.action = { [weak self] _ in
                self?.avoidCountry(country)
            }
        } else {
            let country = avoidedCountries[section-transitCountries.count-1]
            header.countryLabel.text = LS("country.\(country.uppercased())")
            header.avoidButton.isHidden = false
            header.avoidButton.title = LS("Cancel avoid")
            header.avoidButton.action = { [weak self] _ in
                self?.cancelAvoidCountry(country)
            }
        }
        return header
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > transitCountries.count {
            return 0
        }
        return allAvodsList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let avoid = allAvodsList[indexPath.row]
        let country = countryFor(indexPath)
        var available = true
        if let c = country, let avoids = availableAvoidsPerCountry[c] {
            available = avoids.contains(NSNumber(value: avoid.rawValue))
        }
        let enabled = isAvoidEnabled(avoid, for: country)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SYMKAvoidTableCell.identifier) as! SYMKAvoidTableCell
        cell.textLabel?.text = avoid.cellTitle
        cell.switcher.isOn = enabled
        cell.setDisabled(!available && enabled)
        cell.avoidSwithed = { [weak self] enabled in
            self?.updateAvoidSetting(with: avoid, for: country, enabled: enabled)
        }
        return cell
    }
    
    private func countryFor(_ indexPath: IndexPath) -> String? {
        if indexPath.section > 0 {
            return transitCountries[indexPath.section-1]
        }
        return nil
    }
    
    private func isAvoidEnabled(_ avoid: SYAvoidType, for country: String?) -> Bool {
        var countryAvoids: Set<NSNumber>? = nil
        if let iso = country, let allAvoids = options.countryAvoids, let currentAvoids = allAvoids[iso] {
            countryAvoids = currentAvoids
        } else if country == nil, let globalAvoids = options.globalAvoids {
            countryAvoids = globalAvoids
        }
        if let foundedAvoids = countryAvoids {
            return !foundedAvoids.contains(NSNumber(value: avoid.rawValue))
        }
        return true
    }
    
    private func updateAvoidSetting(with avoid: SYAvoidType, for country: String?, enabled: Bool) {
        let avoidNumber = NSNumber(value: avoid.rawValue)
        if let country = country {
            var countryAvoids: [String: Set<NSNumber>] = options.countryAvoids ?? Dictionary()
            countryAvoids[country] = modifiedAvoids(avoidSet: countryAvoids[country], avoidNumber: avoidNumber, enabled: enabled)
            if countryAvoids.count == 0 {
                options.countryAvoids = nil
            } else {
                options.countryAvoids = countryAvoids
            }
        } else {
            options.globalAvoids = modifiedAvoids(avoidSet: options.globalAvoids, avoidNumber: avoidNumber, enabled: enabled)
        }
        
        modified = true
        tableView.reloadData()
    }
    
    private func modifiedAvoids(avoidSet: Set<NSNumber>?, avoidNumber: NSNumber, enabled: Bool) -> Set<NSNumber>? {
        var avoids: Set<NSNumber>? = avoidSet ?? Set()
        if !enabled {
            avoids?.insert(avoidNumber)
        } else {
            avoids?.remove(avoidNumber)
            if let existingAvoids = avoids, existingAvoids.count == 0 {
                avoids = nil
            }
        }
        return avoids
    }
    
    private func avoidCountry(_ country: String) {
        transitCountries.removeAll { $0 == country }
        avoidedCountries.append(country)
        updateAvoidSetting(with: .country, for: country, enabled: false)
        tableView.reloadData()
    }
    
    private func cancelAvoidCountry(_ country: String) {
        avoidedCountries.removeAll { $0 == country }
        transitCountries.append(country)
        updateAvoidSetting(with: .country, for: country, enabled: true)
        tableView.reloadData()
    }
}

private class SYMKAvoidTableCell: UITableViewCell {
    static let identifier = "avoidCellIdentifier"
    var avoidSwithed: ((_ enabled: Bool)->())?
    let switcher = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        switcher.addTarget(self, action: #selector(switcherValueChanged(_:)), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switcher)
        switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switcher.trailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDisabled(_ disabled: Bool) {
        switcher.isEnabled = !disabled
        if disabled {
            switcher.isOn = false
        }
        textLabel?.textColor = disabled ? .gray : .accentSecondary
    }
    
    @objc func switcherValueChanged(_ switcher: UISwitch) {
        avoidSwithed?(switcher.isOn)
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

class SYMKRouteOptionsCountryHeader: UITableViewHeaderFooterView {
    
    static let identifier = "RouteOptionCountryHeader"
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = SYUIFont.with(.semiBold, size: SYUIFontSize.headingOld)
        return label
    }()
    
    let avoidButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .plain
        button.titleSize = SYUIFontSize.headingOld
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        heightAnchor.constraint(equalToConstant: SYUIActionButtonSize.infobar.rawValue).isActive = true
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countryLabel)
        countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avoidButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avoidButton)
        avoidButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        avoidButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
