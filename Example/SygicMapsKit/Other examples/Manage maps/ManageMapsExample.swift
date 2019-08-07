//// ManageMapsExample.swift
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
import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit

class ManageMapsViewController: UITableViewController {
    
    var groups: [SYMapLoaderMapGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        SYMKSdkManager.shared.initializeIfNeeded { (_) in
            SYMapLoader.shared().delegate = self
            SYMapLoader.shared().getMapGroups()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = groups[indexPath.row].title
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapsVC = ManageMapsPackagesViewController()
        mapsVC.group = groups[indexPath.row]
        navigationController?.pushViewController(mapsVC, animated: true)
    }
}

extension ManageMapsViewController: SYMapLoaderDelegate {
    func mapLoader(_ mapLoader: SYMapLoader, didGet groups: [SYMapLoaderMapGroup], from task: SYTask) {
        self.groups = groups
        tableView.reloadData()
        
        if task.status != .success {
            let alert = UIAlertController(title: "SYTask status \(task.status)", message: task.statusInfo, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
    }
}


////////////////////


class ManageMapsPackagesViewController: UITableViewController {
    var group: SYMapLoaderMapGroup!
    var packages: [SYMapLoaderMapPackage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Offline maps", style: .plain, target: self, action: #selector(shortcutToMap))
        tableView.register(UINib(nibName: "MapPackageCell", bundle: nil), forCellReuseIdentifier: "MapPackageCell")
        
        SYMapLoader.shared().delegate = self
        SYMapLoader.shared().getMapPackages(for: group)
    }
    
    @objc func shortcutToMap() {
        SYMKSdkManager.shared.onlineMapsEnabled = false
        navigationController?.pushViewController(SYMKBrowseMapViewController(), animated: true)
    }
    
    func formattedSize(_ size: UInt) -> String {
        var mapSize = Double(size)
        if mapSize < 1024 {
            return String(format: "%.0fB", mapSize)
        }
        mapSize = mapSize/1024
        if mapSize < 1024 {
            return String(format: "%.0fkB", mapSize)
        }
        mapSize = mapSize/1024
        return String(format: "%.1fMB", mapSize)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapPackageCell") as? MapPackageCell else { return UITableViewCell() }
        let package = packages[indexPath.row]
        cell.mapTitleLabel.text = package.title
        cell.mapSizeLabel.text = formattedSize(package.sizeOnDisk)
        let mapStatus = package.status()
        cell.progress.isHidden = mapStatus == .loaded || mapStatus == .notInstalled
        cell.accessoryType = (mapStatus == SYMapLoaderMapPackageStatus.loaded ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SYMapLoader.shared().installMapPackage(packages[indexPath.row])
    }
}

extension ManageMapsPackagesViewController: SYMapLoaderDelegate {
    func mapLoader(_ mapLoader: SYMapLoader, didGetMapPackagesFor mapGroup: SYMapLoaderMapGroup, packages: [SYMapLoaderMapPackage], from task: SYTask) {
        self.packages = packages
        tableView.reloadData()
    }
    
    func mapLoader(_ maploader: SYMapLoader, didUpdateMapPackageInstallProgress progress: SYPackageInstallProgress, for package: SYMapLoaderMapPackage, from task: SYTask) {
        guard progress.totalSize != 0 else { assert(true); return }
        let prog = Float(progress.downloadedSize)/Float(progress.totalSize)
        print("progresss \(package.title): \(package.status().rawValue) (\(prog))")
        
        if let index = packages.index(of: package), let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MapPackageCell {
            cell.progress.isHidden = false
            cell.progress.progress = prog
            cell.mapSizeLabel.text = "\(formattedSize(progress.downloadedSize))/\(formattedSize(progress.totalSize))"
        }
    }
    
    func mapLoader(_ maploader: SYMapLoader, didInstallMapPackage package: SYMapLoaderMapPackage, from task: SYTask) {
        print("installed \(package.title): \(package.status().rawValue)")
        if package.status() == .unloaded {
            maploader.load([package])
        }
    }
    
    func mapLoader(_ mapLoader: SYMapLoader, didLoad package: SYMapLoaderMapPackage, with result: SYMapLoaderLoadPackageResult) {
        if result == .loadSuccess {
            print("Map loaded: \(package.countryIso ?? "ApplicationData")")
        }
        tableView.reloadData()
    }
}

class MapPackageCell: UITableViewCell {
    @IBOutlet weak var mapTitleLabel: UILabel!
    @IBOutlet weak var mapSizeLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
}
