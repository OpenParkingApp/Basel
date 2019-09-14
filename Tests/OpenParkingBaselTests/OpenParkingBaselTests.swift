import XCTest
import OpenParkingTests
import OpenParkingBasel

final class OpenParkingBaselTests: XCTestCase {
    func testDatasource() throws {
        assert(datasource: Basel(), ignoreExceededCapacity: true)
    }

    static var allTests = [
        ("testDatasource", testDatasource),
    ]
}
