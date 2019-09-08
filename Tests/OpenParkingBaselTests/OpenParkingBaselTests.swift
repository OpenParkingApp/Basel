import XCTest
import OpenParkingBasel

final class OpenParkingBaselTests: XCTestCase {
    func testExample() throws {
        let data = try Basel().data()
        XCTAssert(!data.lots.isEmpty)

        for lot in data.lots {
            print(lot)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
