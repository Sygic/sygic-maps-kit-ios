//// SYMKPoiDetailViewController.swift
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
    public init(with data: SYMKPoiDetailModel) {
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
