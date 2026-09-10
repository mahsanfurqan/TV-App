import XCTest

final class SwiftBoilerplateUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testShowsScreenLaunches() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["TV Shows"].waitForExistence(timeout: 5))
    }
}
