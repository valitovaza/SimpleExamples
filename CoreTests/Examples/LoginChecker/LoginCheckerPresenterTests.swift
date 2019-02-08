import XCTest
import Core

class LoginCheckerPresenterTests: XCTestCase {

    private var sut: LoginCheckerPresenter!
    private var router: LoginCheckerRouterSpy!
    
    override func setUp() {
        router = LoginCheckerRouterSpy()
        sut = LoginCheckerPresenter(router)
    }

    override func tearDown() {
        router = nil
        sut = nil
    }
    
    func testTaskStartedOpensLoadingScreen() {
        sut.taskStarted()
        XCTAssertEqual(router.openLoadingScreenCallCount, 1)
        XCTAssertEqual(router.openContentScreenCallCount, 0)
        XCTAssertEqual(router.openLoginScreenCallCount, 0)
    }
    
    func testAuthorizedFinishOpensContentScreen() {
        sut.taskFinished(.authorized)
        XCTAssertEqual(router.openLoadingScreenCallCount, 0)
        XCTAssertEqual(router.openContentScreenCallCount, 1)
        XCTAssertEqual(router.openLoginScreenCallCount, 0)
    }
    
    func testNotAuthorizedFinishOpensLoginScreen() {
        sut.taskFinished(.notAuthorized)
        XCTAssertEqual(router.openLoadingScreenCallCount, 0)
        XCTAssertEqual(router.openContentScreenCallCount, 0)
        XCTAssertEqual(router.openLoginScreenCallCount, 1)
    }
}
extension LoginCheckerPresenterTests {
    class LoginCheckerRouterSpy: LoginCheckerRouter {
        var openLoadingScreenCallCount = 0
        func openLoadingScreen() {
            openLoadingScreenCallCount += 1
        }
        
        var openContentScreenCallCount = 0
        func openContentScreen() {
            openContentScreenCallCount += 1
        }
        
        var openLoginScreenCallCount = 0
        func openLoginScreen() {
            openLoginScreenCallCount += 1
        }
    }
}
