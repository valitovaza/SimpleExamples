import XCTest
@testable import SimpleExamples

class ErrorHandlingNavigatorTests: XCTestCase {

    private var sut: ErrorHandlingNavigatorImpl!
    private var logger: ErrorLoggerSpy!
    private var navigator: NavigatorMock!
    
    override func setUp() {
        logger = ErrorLoggerSpy()
        navigator = NavigatorMock()
        sut = ErrorHandlingNavigatorImpl(navigator, logger)
    }

    override func tearDown() {
        logger = nil
        navigator = nil
        sut = nil
    }
    
    func testOpenInvokesNavigatorsOpen() {
        let vc = UIViewController()
        sut.open(viewController: vc, animated: false)
        XCTAssertEqual(navigator.openCallCount, 1)
        XCTAssertEqual(navigator.opennedVc, vc)
        XCTAssertEqual(navigator.openAnimatedFlag, false)
        XCTAssertEqual(logger.logCallCount, 0)
    }
    
    func testOpenWithErrorInvokesLogError() {
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        sut.open(viewController: UIViewController(), animated: true)
        XCTAssertEqual(logger.logCallCount, 1)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantPresentAlreadyPresentedViewController)
    }
    
    func testPushInvokesNavigatorsPush() {
        let vc = UIViewController()
        sut.push(viewController: vc, animated: true)
        XCTAssertEqual(navigator.pushCallCount, 1)
        XCTAssertEqual(navigator.pushedVc, vc)
        XCTAssertEqual(navigator.pushAnimatedFlag, true)
    }
    
    func testWhenCanNotPushErrorLogAndTryToOpen() {
        navigator.nextErrors = [.cantPush]
        let vc = UIViewController()
        sut.push(viewController: vc, animated: true)
        XCTAssertEqual(logger.logCallCount, 1)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantPush)
        
        XCTAssertEqual(navigator.openCallCount, 1)
        XCTAssertEqual(navigator.openAnimatedFlag, true)
    }
    
    func testWhenCanNotPushErrorLoggingInvokesBeforeOpen() {
        logger.interceptionCallback = {[unowned self] in
            XCTAssertEqual(self.navigator.openCallCount, 0)
        }
        navigator.nextErrors = [.cantPushAlert]
        let vc = UIViewController()
        sut.push(viewController: vc, animated: true)
    }
    
    func testWhenCanNotPushAndCanNotOpenLog2Errors() {
        navigator.nextErrors = [.cantPush,
                                .cantPresentAlreadyPresentedViewController]
        let vc = UIViewController()
        sut.push(viewController: vc, animated: true)
        XCTAssertEqual(logger.logCallCount, 2)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantPresentAlreadyPresentedViewController)
    }
    
    func testBackInvokesNavigatorsBack() {
        sut.back(animated: false)
        XCTAssertEqual(navigator.backCallCount, 1)
        XCTAssertEqual(navigator.backAnimatedFlag, false)
    }
    
    func testBackWithErrorInvokesLog() {
        navigator.nextErrors = [.cantNavigateBack]
        sut.back(animated: true)
        XCTAssertEqual(logger.logCallCount, 1)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantNavigateBack)
    }
    
    func testAddContentScreenInvokesNavigatorsAddContentScreen() {
        let vc = UIViewController()
        sut.add(contentScreen: vc)
        XCTAssertEqual(navigator.addContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addedVc, vc)
        XCTAssertEqual(logger.logCallCount, 0)
    }
    
    func testAddContentWithErrorInvokesLog() {
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        sut.add(contentScreen: UIViewController())
        XCTAssertEqual(logger.logCallCount, 1)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantPresentAlreadyPresentedViewController)
    }
    
    func testRemoveContentScreenInvokesNavigatorsRemoveContent() {
        sut.removeLastContentScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
        XCTAssertEqual(logger.logCallCount, 0)
    }
    
    func testRemoveContentScreenWithErrorInvokesLog() {
        navigator.nextErrors = [.cantNavigateBack]
        sut.removeLastContentScreen()
        XCTAssertEqual(logger.logCallCount, 1)
        XCTAssertEqual(logger.loggedError as? NavigatorError,
                       NavigatorError.cantNavigateBack)
    }
}
extension ErrorHandlingNavigatorTests {
    class ErrorLoggerSpy: ErrorLogger {
        var logCallCount = 0
        var loggedError: Error?
        var interceptionCallback: (()->())?
        func log(error: Error) {
            logCallCount += 1
            loggedError = error
            interceptionCallback?()
        }
    }
}
