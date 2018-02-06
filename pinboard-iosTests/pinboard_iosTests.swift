import XCTest
import SweetSwift
@testable import pinboard_ios

class pinboard_iosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFonts() {
        // Ensure fonts exist.
        20.times { i in
            let size = CGFloat(i + 5)
            XCTAssertNotNil(UIFont.avenirBook(size: size))
            XCTAssertNotNil(UIFont.avenirHeavy(size: size))
        }
    }
}
