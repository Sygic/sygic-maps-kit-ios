//// SygicMapsKit_UITests.swift
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

import KIF
import SygicMapsKit


class BrowseModule_UITests: KIFTestCase {

    override func beforeAll() {
        let tableView = tester.waitForView(withAccessibilityLabel: "tableView.root") as! UITableView
        // Browse examples
        tester.tapRow(at: IndexPath(item: 0, section: 0), in: tableView)
    }
    
    override func afterEach() {
        tester.tapView(withAccessibilityLabel: "Browse Map Examples")
    }
    
    override func afterAll() {
        tester.tapView(withAccessibilityLabel: "Back")
        SYMKSdkManager.shared.terminate()
    }
    
    // MARK: - Tests
    
    /// Default browse map
    func testBrowseDefault() {
        let browseIndex = IndexPath(item: 0, section: 0)
        goToBrowseSample(at: browseIndex)
        
        let map = tester.waitForView(withAccessibilityLabel: "Map")
        let browse = tester.waitForView(withAccessibilityLabel: "view.browseModule.root") as! SYMKBrowseMapView
        
        XCTAssertNil(browse.compass)
        XCTAssertNil(browse.recenterButton)
        XCTAssertNil(browse.zoomControl)
        XCTAssertNotNil(browse.mapView)
        XCTAssertTrue(!map!.isHidden)
    }
    
    /// Customized browse map
    func testBrowseMapAllVisible() {
        let browseIndex = IndexPath(item: 1, section: 0)
        goToBrowseSample(at: browseIndex)
        
        tester.wait(forTimeInterval: 2)
        let map = tester.waitForView(withAccessibilityLabel: "Map")
        
        // system Location permissions alert
        tester.acknowledgeSystemAlert()
        
        let browse = tester.waitForView(withAccessibilityLabel: "view.browseModule.root") as! SYMKBrowseMapView
        
        XCTAssertNotNil(browse.compass)
        XCTAssertNotNil(browse.recenterButton)
        XCTAssertNotNil(browse.zoomControl)
        XCTAssertNotNil(browse.mapView)
        XCTAssertTrue(!map!.isHidden)
        
        map?.twoFingerRotate(at: map!.center, angle: 60)
        tester.waitForAnimationsToFinish()
        tester.waitForView(withAccessibilityLabel: "native.compas")?.tap()
        tester.wait(forTimeInterval: 1)
        
        // tap map to show PoiDetail
        map?.tap(at: map!.center)
        tester.wait(forTimeInterval: 3)
        
        // tap title to expand
        let titleCell = cellIndexPath(for: viewTester.usingIdentifier("PoiDetailAddressCell.titleLabel")?.waitForView())
        XCTAssertNotNil(titleCell)
        let poiDetailTable = viewTester.usingIdentifier("PoiDetailView.tableView")?.waitForView() as! UITableView
        tester.tapRow(at: IndexPath(row: 0, section: 0), in: poiDetailTable)
        tester.wait(forTimeInterval: 3)
        
        // copy coordinates
        let gpsCell = cellIndexPath(for: viewTester.usingLabel("GPS")?.waitForView())
        XCTAssertNotNil(gpsCell)
        gpsCell!.longPress(at: gpsCell!.tappablePoint(in: gpsCell!.bounds), duration: 2)
        tester.wait(forTimeInterval: 3)
        viewTester.usingLabel("Copy")?.waitForTappableView()?.tap()
        tester.wait(forTimeInterval: 2)
        
        // collapse
        tester.tapRow(at: IndexPath(row: 0, section: 0), in: poiDetailTable)
        tester.wait(forTimeInterval: 3)
        
        // dismiss PoiDetail
        map?.tap(at: CGPoint(x: 100, y: 100))
        tester.wait(forTimeInterval: 3)
        
        // lock position
        let lockButton = viewTester.usingIdentifier("actionButton")?.waitForTappableView()
        XCTAssertNotNil(lockButton)
        lockButton?.tap()
        tester.wait(forTimeInterval: 1)
        
        // zoom controls
        let zoomButton = viewTester.usingLabel("")?.waitForTappableView()
        XCTAssertNotNil(zoomButton)
        zoomButton?.tap()
        tester.wait(forTimeInterval: 1)
        viewTester.usingLabel("")?.waitForTappableView()?.tap()
        tester.wait(forTimeInterval: 1)
    }
    
    /// Custom tap handling
    func testBrowseMapCustomTap() {
        let browseIndex = IndexPath(item: 2, section: 0)
        goToBrowseSample(at: browseIndex)
        
        let map = tester.waitForView(withAccessibilityLabel: "Map")
        XCTAssertNotNil(map)
        
        tester.wait(forTimeInterval: 1)
        map!.tap(at: map!.center)
        tester.wait(forTimeInterval: 1)
        
        // test alert dismiss
        tester.tapView(withAccessibilityLabel: "Ok")
    }
    
    /// Custom annotations
//    func testCustomAnnotations() {
//        let browseIndex = IndexPath(item: 3, section: 0)
//        goToBrowseSample(at: browseIndex)
//
//        tester.wait(forTimeInterval: 2)
//        let map = tester.waitForView(withAccessibilityLabel: "Map")
//        XCTAssertNotNil(map)
//
//        tester.wait(forTimeInterval: 2)
//        map!.tap(at: map!.center)
//        tester.wait(forTimeInterval: 2)
//
//        // test annotation appear
//        let annotationView = viewTester.usingIdentifier("DataAnnotation")?.waitForView()
//        XCTAssertNotNil(annotationView)
//    }
    
    /// Skins
    func testCustomSkinExample() {
        let browseIndex = IndexPath(item: 4, section: 0)
        goToBrowseSample(at: browseIndex)
        
        let map = tester.waitForView(withAccessibilityLabel: "Map")
        XCTAssertNotNil(map)
    }
    
    /// Custom markers
    func testCustomMarkers() {
        let browseIndex = IndexPath(item: 5, section: 0)
        goToBrowseSample(at: browseIndex)
        
        let map = tester.waitForView(withAccessibilityLabel: "Map")
        XCTAssertNotNil(map)
        
        tester.wait(forTimeInterval: 3)
        map!.tap(at: map!.center)
        tester.wait(forTimeInterval: 3)
        
        let customMarkerTitle = viewTester.usingLabel("Super custom POI")?.waitForView()
        XCTAssertNotNil(customMarkerTitle)
    }
    
    /// Map selection modes
    func testSelectionModes() {
        let browseIndex = IndexPath(item: 6, section: 0)
        goToBrowseSample(at: browseIndex)
        
        let modesButton = viewTester.usingIdentifier("Selection mode")?.waitForTappableView()
        XCTAssertNotNil(modesButton)
        
        modesButton?.tap()
        tester.wait(forTimeInterval: 1)
        tester.tapView(withAccessibilityLabel: "All")
        tester.wait(forTimeInterval: 1)
        modesButton?.tap()
        tester.wait(forTimeInterval: 1)
        tester.tapView(withAccessibilityLabel: "Markers only")
        tester.wait(forTimeInterval: 1)
        modesButton?.tap()
        tester.wait(forTimeInterval: 1)
        tester.tapView(withAccessibilityLabel: "None")
        tester.wait(forTimeInterval: 1)
    }
    
    
    //MARK: - Private
    
    private func goToBrowseSample(at indexPath: IndexPath) {
        let browseTable = tester.waitForView(withAccessibilityLabel: "tableView.browseSamples") as! UITableView
        tester.waitForCell(at: indexPath, in: browseTable)
        tester.tapRow(at: indexPath, in: browseTable)
    }
    
    private func cellIndexPath(for view: UIView!) -> UITableViewCell? {
        var superview = view.superview
        while superview != nil {
            if let cell = superview as? UITableViewCell {
                return cell
            }
            superview = superview?.superview
        }
        return nil
    }
}
