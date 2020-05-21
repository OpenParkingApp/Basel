import XCTest
import DatasourceValidation
import Basel

final class BaselTests: XCTestCase {
    func testDatasource() throws {
        validate(datasource: Basel(), ignoreExceededCapacity: true)
    }
}
