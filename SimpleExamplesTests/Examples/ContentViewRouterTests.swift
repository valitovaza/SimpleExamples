import XCTest
@testable import SimpleExamples

class ContentViewRouterTests: XCTestCase {

    private var sut: ContentViewRouterImpl!
    private var navigator: ErrorHandlingNavigatorSpy!
    
    private let counterVc = UIViewController()
    
    override func setUp() {
        navigator = ErrorHandlingNavigatorSpy()
        sut = ContentViewRouterImpl(navigator, { self.counterVc })
    }

    override func tearDown() {
        navigator = nil
        sut = nil
    }
    
    func testOpenCounterScreenInvokesPush() {
        sut.openCounterScreen()
        XCTAssertEqual(navigator.pushCallCount, 1)
        XCTAssertEqual(navigator.pushedVc, counterVc)
        XCTAssertEqual(navigator.pushAnimatedFlag, true)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.addContentScreenCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
}
