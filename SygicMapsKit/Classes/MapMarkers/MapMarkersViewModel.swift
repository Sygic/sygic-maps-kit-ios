//import Foundation
//import SygicNavi
//import RxSwift
//
//public protocol MapObjectsManager {
//    var selectedMapMarkers: PublishSubject<[SYMapMarker]> { get }
//    var subviews: [UIView] { get }
//
//    func addMapObject(_ mapObject: SYMapObject)
//    func removeMapObject(_ mapObject: SYMapObject)
//
//    func addSubview(_ subview: UIView)
//}
//
//public protocol MarkersVisibilityManager {
//    func showAllMarkers()
//    func hideAllMarkers()
//}
//
//public protocol MapMarkerItem: Equatable {
//    var mapMarker: SYMapMarker { get }
//    var markerView: UIView { get }
//}
//
//public class MapMarkersManager<T: MapMarkerItem> {
//
//    public var didSelectAction: ((T) -> Void)?
//    public private(set) var markerItems = [T]()
//    internal let mapObjectsManager: MapObjectsManager
//    private let disposeBag = DisposeBag()
//    internal var cluster: SYMapMarkersCluster?
//
//    // MARK: - Initialization
//
//    public init(with mapObjectsManager: MapObjectsManager) {
//        self.mapObjectsManager = mapObjectsManager
//
//        setupRx(for: mapObjectsManager.selectedMapMarkers)
//    }
//
//    deinit {
//        removeAllMarkers()
//    }
//
//    public func setCluster(_ cluster: SYMapMarkersCluster) {
//        self.cluster = cluster
//    }
//
//    // MARK: - Adding & Removing markers
//
//    public func addMarkerItem(_ markerItem: T, at index: Int? = nil) {
//        if markerItems.contains(markerItem) {
//            return
//        }
//
//        if let index = index {
//            markerItems.insert(markerItem, at: index)
//        } else {
//            markerItems.append(markerItem)
//        }
//        mapObjectsManager.addMapObject(markerItem.mapMarker)
//    }
//
//    public func addStaticMarkerItem(_ markerItem: T) {
//        if markerItems.contains(markerItem) {
//            return
//        }
//
//        markerItems.append(markerItem)
//        mapObjectsManager.addSubview(markerItem.markerView)
//    }
//
//    public func removeMarkerItem(_ markerItem: T) {
//        guard let markerToRemove = markerItems.first(where: { $0 == markerItem }) else { return }
//
//        markerToRemove.markerView.removeFromSuperview()
//        cluster?.removeMapMarker(markerToRemove.mapMarker)
//        mapObjectsManager.removeMapObject(markerToRemove.mapMarker)
//
//        markerItems = markerItems.filter { $0 != markerItem }
//    }
//
//    public func removeAllMarkers() {
//        markerItems.forEach { removeMarkerItem($0) }
//    }
//}
//
//// MARK: - MarkersVisibilityManager
//extension MapMarkersManager: MarkersVisibilityManager {
//    public func showAllMarkers() {
//        for markerItem in markerItems {
//            markerItem.mapMarker.visibility = true
//        }
//    }
//
//    public func hideAllMarkers() {
//        for markerItem in markerItems {
//            markerItem.mapMarker.visibility = false
//        }
//    }
//}
//
//// MARK: - Private methods
//extension MapMarkersManager {
//
//    // MARK: - Handling selected objects
//
//    private func setupRx(for selectedMapMarkers: PublishSubject<[SYMapMarker]>) {
//        selectedMapMarkers.asObservable()
//            .subscribe(onNext: { [weak self] (viewObjects) in
//
//                if let selectedMarkerItem = self?.markerItems.first(where: { viewObjects.contains($0.mapMarker) }) {
//                    self?.didSelectAction?(selectedMarkerItem)
//                }
//
//            })
//            .disposed(by: disposeBag)
//    }
//
//}
