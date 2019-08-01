//// NavigationExamplesTableViewController.swift
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
import SygicMapsKit


class NavigationExamplesTableViewController: UITableViewController {
    
    let modulesData = [
        ModuleData(title: "Navigation demo", subtitle: "Navigation module with predefined route preview", image: "preview-browsemap-default"),
        ModuleData(title: "Navigation from current location", subtitle: "Navigation module with route computed to current location", image: "preview-browsemap-default"),
        ModuleData(title: "Navigation instructions type", subtitle: "Instruction types for navigation", image: "preview-browsemap-default")
    ]
    
    private let cellHeight: CGFloat = 330
    private let reuseIdentifier = String(describing: ModuleExampleTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Navigation Examples"
        tableView.accessibilityLabel = "tableView.browseSamples"
        tableView.register(UINib(nibName: "ModuleExampleTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ModuleExampleTableViewCell
        let data = modulesData[indexPath.row]
        cell.title = data.title
        cell.subtitle = data.subtitle
        cell.imageName = data.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(NavigationExampleViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(CurrentLocationNavigationExampleViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(NavigationSignpostsExampleViewController(), animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

}
