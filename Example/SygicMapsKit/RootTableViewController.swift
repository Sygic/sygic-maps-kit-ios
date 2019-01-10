import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit


class RootTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Browse Map Module"
        case 1:
            cell.textLabel?.text = "Custom Pois"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BrowseMapModuleExample(), animated: true)
        case 1:
            navigationController?.pushViewController(sampleBrowseMapWithCustomPois(), animated: true)
        default:
            break
        }
    }
    
    
    //MARK: - Samples
    
    private func sampleBrowseMapWithCustomPois() -> UIViewController {
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.customMarkers = customMarkers()
        return browseMapModule
    }
    
    
    //MARK: - Helpers
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = pinWithEverything()
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SYUIIcon.android, color: .green)!
        let pin3 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SYUIIcon.sygic, color: .red)!
        return [pin1, pin2, pin3]
    }
    
    private func pinWithEverything() -> SYMKMapPin {
        var data = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!)
        data.name = "Super custom POI"
        data.street = "Mlynske Nivy"
        data.houseNumber = "16"
        data.city = "Bratislava"
        data.postal = "831 09"
        data.website = "www.sygic.com"
        
        let marker = SYMKMapPin(coordinate: data.coordinate, icon: SYUIIcon.apple, color: .gray, highlighted: false)!
        marker.data = data
        return marker
    }
}
