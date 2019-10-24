import Quick
import Nimble
import SygicMaps
import SygicMapsKit

class SYMKMapSelectionManagerTests: QuickSpec {
    
    var selectionManager = SYMKMapSelectionManager(with: .markers)
    var selectedData: SYMKPlaceDataProtocol?

    override func spec() {

        describe("Map selection manager") {
            context("select PIN") {
                beforeEach {
                    self.selectionManager.delegate = self
                    self.selectedData = nil
                }
                
                it("returns pois data") {
                    
                    let mockData = SYMKPoiData(with: SYGeoCoordinate(latitude: 47, longitude: 52))
                    
                    let marker = SYMapMarker(with: mockData)
                    self.selectionManager.addCustomMarker(marker)
                    
                    self.selectionManager.selectMapObjects([marker])
                    
                    expect(self.selectedData).to(beAKindOf(SYMKPoiData.self))
                    expect(self.selectedData?.location).to(beIdenticalTo(mockData.location))
                }
            }
        }

    }
}

extension SYMKMapSelectionManagerTests: SYMKMapSelectionDelegate {
    
    func mapSelectionShouldAddMarkerToMap(location: SYGeoCoordinate) -> SYMapMarker? {
        return SYMapMarker(with: SYMKPlaceData(with: location))
    }
    
    func mapSelectionWillSelectData(_ mapSelection: SYMKMapSelectionManager) { }
    
    func mapSelection(didSelect poiData: SYMKPlaceDataProtocol) {
        selectedData = poiData
    }
    
    func mapSelectionDidTapOnMap(selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool {
        return true
    }
    
    func mapSelectionPoiDetailWasShown() -> Bool {
        return true
    }
    
}
