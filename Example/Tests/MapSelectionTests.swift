import Quick
import Nimble
import SygicMaps
import SygicMapsKit

class MapSelectionTests: QuickSpec {
    
    var selectionManager = SYMKMapSelectionManager(with: .markers)
    var selectedData: SYMKPoiDataProtocol?

    override func spec() {

        describe("Map selection manager") {
            context("select PIN") {
                beforeEach {
                    self.selectionManager.delegate = self
                    self.selectedData = nil
                }
                
                it("returns pois data") {
                    
                    let mockData = SYMKPoiData(with: SYGeoCoordinate(latitude: 47, longitude: 52)!)
                    
                    let pin = SYMKMapPin(data: mockData)!
                    self.selectionManager.addCustomPin(pin)
                    
                    self.selectionManager.selectMapObjects([pin.mapMarker])
                    
                    expect(self.selectedData).to(beAKindOf(SYMKPoiData.self))
                    expect(self.selectedData?.coordinate).to(beIdenticalTo(mockData.coordinate))
                }
            }
        }

    }
}

extension MapSelectionTests: SYMKMapSelectionDelegate {
    func mapSelectionShouldAddPoiPin() -> Bool {
        return false
    }
    func mapSelection(didSelect poiData: SYMKPoiDataProtocol) {
        selectedData = poiData
    }
    func mapSelectionDeselectAll() {
        
    }
}
