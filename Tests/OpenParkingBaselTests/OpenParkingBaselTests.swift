import XCTest
@testable import OpenParkingBasel

final class OpenParkingBaselTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OpenParkingBasel().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
