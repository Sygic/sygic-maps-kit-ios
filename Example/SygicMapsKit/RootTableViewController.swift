//// RootTableViewController.swift
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
import SygicMapsKit


class RootTableViewController: UITableViewController {
    
    let mapsKitGithub = "https://github.com/Sygic/sygic-maps-kit-ios"
    let mapsKitWiki = "https://github.com/Sygic/sygic-maps-kit-ios/wiki"
    let sectionsData = [" ", "Modules", "Getting started!"]
    let rowsData = [["DEMO"],
                    ["Browse Map", "Search", "Navigation", "Double map", "Manage Maps"],
                    ["Source code", "Wiki"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityLabel = "tableView.root"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsData[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = rowsData[indexPath.section][indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(DemoViewController(), animated: true)
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(BrowseExamplesTableViewController(), animated: true)
            case 1:
                navigationController?.pushViewController(SearchExamplesTableViewController(), animated: true)
            case 2:
                navigationController?.pushViewController(NavigationExamplesTableViewController(), animated: true)
            case 3:
                navigationController?.pushViewController(DoubleMapViewController(), animated: true)
            case 4:
                navigationController?.pushViewController(ManageMapsViewController(), animated: true)
            default:
                break
            }
        } else if indexPath.section == 2 {
            let url = indexPath.row == 0 ? mapsKitGithub : mapsKitWiki
            guard let safariUrl = URL(string: url) else { return }
            UIApplication.shared.open(safariUrl)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
