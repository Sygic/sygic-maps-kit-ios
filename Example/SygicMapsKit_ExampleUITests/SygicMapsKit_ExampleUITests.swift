import XCTest

class SygicMapsKit_ExampleUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func testBrowseMapExamples() {
        
        var map: XCUIElement
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Browse Map"]/*[[".cells.staticTexts[\"Browse Map\"]",".staticTexts[\"Browse Map\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        /// Default browse map
        app.tables.cells.staticTexts["Browse Map - Default"].tap()
        map = app.otherElements.matching(identifier: "Map").element
        XCTAssertTrue(map.waitForExistence(timeout: 10))
        app.navigationBars["SygicMapsKit.SYMKBrowseMapView"].buttons["Browse Map Examples"].tap()
        
        
        /// Customized browse map
        let example2 = app.tables.cells.staticTexts["Browse Map - Full"]
        XCTAssertTrue(example2.waitForExistence(timeout: 3))
        example2.tap()
        
        let alertGPSAccess = app.alerts["Allow “SygicMapsKit_Example” to access your location while you are using the app?"]
        if alertGPSAccess.waitForExistence(timeout: 2) {
            alertGPSAccess.buttons["Allow"].tap()
        }
        
        map = app.otherElements.matching(identifier: "Map").element
        XCTAssertTrue(map.waitForExistence(timeout: 5))
        
        map.rotate(1, withVelocity: 0.8)
        let compass = app.otherElements["native.compas"]
        XCTAssertTrue(compass.waitForExistence(timeout: 2))
        compass.tap()
        
        map.tap()
        
        let poiDetailHeaderTitle = app.tables["PoiDetailView.tableView"].staticTexts["PoiDetailAddressCell.titleLabel"]
        XCTAssertTrue(poiDetailHeaderTitle.waitForExistence(timeout: 2))
        poiDetailHeaderTitle.tap()
        
        app.tables["PoiDetailView.tableView"]/*@START_MENU_TOKEN@*/.cells.staticTexts["GPS"].press(forDuration: 1.0);/*[[".cells.staticTexts[\"GPS\"]",".tap()",".press(forDuration: 1.0);",".staticTexts[\"GPS\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[1,0]]@END_MENU_TOKEN@*/
        app/*@START_MENU_TOKEN@*/.menuItems["Copy"]/*[[".menus.menuItems[\"Copy\"]",".menuItems[\"Copy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(poiDetailHeaderTitle.waitForExistence(timeout: 2))
        poiDetailHeaderTitle.tap()
        
        XCTAssertTrue(map.waitForExistence(timeout: 1))
        map.tap()
        
        app.buttons["actionButton"].tap()
        app.buttons[""].tap()
        app.buttons[""].tap()

        app.navigationBars["SygicMapsKit.SYMKBrowseMapView"].buttons["Browse Map Examples"].tap()
        
        
        /// Custom tap handling
        let example3 = app.tables.cells.staticTexts["Browse Map - Tap handling"]
        XCTAssertTrue(example3.waitForExistence(timeout: 3))
        example3.tap()
        
        map = app.otherElements.matching(identifier: "Map").element
        XCTAssertTrue(map.waitForExistence(timeout: 5))
        map.tap()
        
        let alertButton = app.alerts.buttons["Ok"]
        XCTAssertTrue(alertButton.waitForExistence(timeout: 5))
        alertButton.tap()
        
        app.navigationBars["Custom Tap Handling Example"].buttons["Browse Map Examples"].tap()
        
        
        /// Custom annotation
        let example4 = app.tables.cells.staticTexts["Browse Map - Custom Annotation View"]
        XCTAssertTrue(example4.waitForExistence(timeout: 3))
        example4.tap()
        
        map = app.otherElements.matching(identifier: "Map").element
        XCTAssertTrue(map.waitForExistence(timeout: 5))
        map.tap()
        
        let annotation = map.otherElements.matching(identifier: "DataAnnotation").element
        XCTAssertTrue(annotation.waitForExistence(timeout: 5))
        
        app.navigationBars["Custom marker info demo"].buttons["Browse Map Examples"].tap()
        
        
        /// Skins
        let example5 = app.tables.cells.staticTexts["Browse Map - Skins"]
        XCTAssertTrue(example5.waitForExistence(timeout: 3))
        example5.tap()
        XCTAssertTrue(app.navigationBars["Skins Example"].waitForExistence(timeout: 2))
        app.navigationBars["Skins Example"].buttons["Browse Map Examples"].tap()
        
        
        /// Custom markers
        let example6 = app.tables.cells.staticTexts["Browse Map - Markers"]
        XCTAssertTrue(example6.waitForExistence(timeout: 3))
        example6.tap()
        
        map = app.otherElements.matching(identifier: "Map").element
        XCTAssertTrue(map.waitForExistence(timeout: 5))
        map.tap()
        
        XCTAssertTrue(app.staticTexts["Super custom POI"].waitForExistence(timeout: 5))
        
        app.navigationBars["Custom Markers Example"].buttons["Browse Map Examples"].tap()
        
        
        /// Selection modes
        let example7 = app.tables.cells.staticTexts["Browse Map - Selection Modes"]
        XCTAssertTrue(example7.waitForExistence(timeout: 3))
        example7.tap()
        
        let modeButton = app.buttons.matching(identifier: "Selection mode").element
        modeButton.tap()
        app.sheets["Selection Modes"].buttons["All"].tap()
        modeButton.tap()
        app.sheets["Selection Modes"].buttons["Markers only"].tap()
        modeButton.tap()
        app.sheets["Selection Modes"].buttons["None"].tap()
        
        app.navigationBars["Selection Modes Example"].buttons["Browse Map Examples"].tap()
        
        
        /// Exit
        app.navigationBars["Browse Map Examples"].buttons["Sygic Maps Kit Samples"].tap()
    }
    
    func testSearchExamples() {
        app.tables.staticTexts["Search"].tap()

        // Search - Default
        app.tables.cells.staticTexts["Search - Default"].tap()
        app.typeText("Eurovea")
        app.tables.staticTexts["Eurovea"].firstMatch.tap()
        app.typeText("zzzzzzzzzzzzzzzz")
        app.tables["Empty list"].tap()
        app.navigationBars["SygicMapsKit.SYMKSearchView"].buttons["Search Examples"].tap()
        
        // Browse Map with Search
        app.tables.cells.staticTexts["Browse Map with Search"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search Button"]/*[[".otherElements[\"view.browseModule.root\"].buttons[\"Search Button\"]",".buttons[\"Search Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.typeText("Sygic")
        app.tables.cells.firstMatch.tap()
        app.alerts.buttons["Ok"].tap()
        app.navigationBars["SygicMapsKit_Example.BrowseMapWithSearchView"].buttons["Search Examples"].tap()
        
        // Search Results on map
        app.tables.cells.staticTexts["Search Results on map"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search Button"]/*[[".otherElements[\"view.browseModule.root\"].buttons[\"Search Button\"]",".buttons[\"Search Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.typeText("Sygic")
        app.tables.cells.firstMatch.tap()
        XCUIApplication().tables["PoiDetailView.tableView"]/*@START_MENU_TOKEN@*/.staticTexts["PoiDetailAddressCell.titleLabel"]/*[[".cells",".staticTexts[\"Sygic\"]",".staticTexts[\"PoiDetailAddressCell.titleLabel\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().navigationBars["SygicMapsKit_Example.BrowseMapWithSearchResults"].buttons["Search Examples"].tap()
        
        // Prefill Search
        app.tables.cells.staticTexts["Prefill Search"].tap()
        app.tables.cells.firstMatch.tap()
        app.navigationBars["SygicMapsKit.SYMKSearchView"].buttons["Search Examples"].tap()
        
    }

}

