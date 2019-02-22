import Foundation
import SygicUIKit


/// Poi Detail controller manages poi detail view.
///
/// This is subclass of `SYUIPoiDetailViewController` in MapsKit framework, so it can be initialized with
/// SYMKPoiDetailModel. Controller creates data source as SYMKPoiDetailDataSource and delegate as SYMKPoiDetailDelegate itself.
public class SYMKPoiDetailViewController: SYUIPoiDetailViewController {
    
    private let data: SYMKPoiDetailModel
    private var poiDetailDataSource: SYMKPoiDetailDataSource?
    private var poiDetailDelegate: SYMKPoiDetailDelegate?
    
    /// Designated constructor with data as SYMKPoiDetailModel
    init(with data: SYMKPoiDetailModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        poiDetailDataSource = SYMKPoiDetailDataSource(with: data)
        poiDetailDelegate = SYMKPoiDetailDelegate(with: data, controller: self)
        
        dataSource = poiDetailDataSource
        delegate = poiDetailDelegate
        
        super.viewDidLoad()
    }
}
