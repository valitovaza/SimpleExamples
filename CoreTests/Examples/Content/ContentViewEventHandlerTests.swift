import XCTest

class ContentViewEventHandlerTests: XCTestCase {

    private var sut: ContentViewEventHandlerImpl!
    private var router: ContentViewRouterSpy!
    
    override func setUp() {
        router = ContentViewRouterSpy()
        sut = ContentViewEventHandlerImpl(router)
    }

    override func tearDown() {
        router = nil
        sut = nil
    }
    
    func testOnCounterActionInvokesOpenCounterVC() {
        sut.onCounterAction()
        XCTAssertEqual(router.openCounterScreenCallCount, 1)
    }
}
extension ContentViewEventHandlerTests {
    class ContentViewRouterSpy: ContentViewRouter {
        var openCounterScreenCallCount = 0
        func openCounterScreen() {
            openCounterScreenCallCount += 1
        }
    }
}
