import Foundation
import SygicUIKit

public class SYMKPoiDetailViewController: SYUIPoiDetailViewController {
    
    private let data: SYMKPoiDetailModel
    private var poiDetailDataSource: SYMKPoiDetailDataSource?
    private var poiDetailDelegate: SYMKPoiDetailDelegate?
    
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
