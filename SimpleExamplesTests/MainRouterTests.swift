import XCTest
@testable import SimpleExamples

class MainRouterTests: XCTestCase {
    
    private var sut: MainRouter!
    private var screenSwitcher: ContainerScreenSwitcherSpy!
    private var navigator: ErrorHandlingNavigatorSpy!
    
    private let loadingVc = UIViewController()
    private let contentVc = UIViewController()
    private let loginVC = UIViewController()
    
    override func setUp() {
        screenSwitcher = ContainerScreenSwitcherSpy()
        navigator = ErrorHandlingNavigatorSpy()
        sut = MainRouter(screenSwitcher, navigator,
                         {self.loadingVc},
                         {self.contentVc},
                         {self.loginVC})
    }
    
    override func tearDown() {
        screenSwitcher = nil
        navigator = nil
        sut = nil
    }
    
    func testOpenLoadingScreenInvokesSetContent() {
        sut.openLoadingScreen()
        XCTAssertEqual(screenSwitcher.setContentCallCount, 1)
        XCTAssertEqual(screenSwitcher.setViewController, loadingVc)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.puchCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
    }
    
    func testOpenContentScreenInvokesSetContent() {
        sut.openContentScreen()
        XCTAssertEqual(screenSwitcher.setContentCallCount, 1)
        XCTAssertEqual(screenSwitcher.setViewController, contentVc)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.puchCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
    }
    
    func testOpenLoginScreenInvokesNavigatorOpen() {
        sut.openLoginScreen()
        XCTAssertEqual(navigator.openCallCount, 1)
        XCTAssertEqual(navigator.openedVc, loginVC)
        XCTAssertEqual(navigator.openAnimatedFlag, true)
        
        XCTAssertEqual(navigator.puchCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(screenSwitcher.setContentCallCount, 0)
    }
}
extension MainRouterTests {
    class ContainerScreenSwitcherSpy: ContainerScreenSwitcher {
        var setContentCallCount = 0
        var setViewController: UIViewController?
        func set(content viewController: UIViewController) {
            setContentCallCount += 1
            setViewController = viewController
        }
    }
    class ErrorHandlingNavigatorSpy: ErrorHandlingNavigator {
        var openCallCount = 0
        var openedVc: UIViewController?
        var openAnimatedFlag: Bool?
        func open(viewController: UIViewController, animated: Bool) {
            openCallCount += 1
            openedVc = viewController
            openAnimatedFlag = animated
        }
        
        var puchCallCount = 0
        var pushedVc: UIViewController?
        var pushAnimatedFlag: Bool?
        func push(viewController: UIViewController, animated: Bool) {
            puchCallCount += 1
            pushedVc = viewController
            pushAnimatedFlag = animated
        }
        
        var backCallCount = 0
        var backAnimatedFlag: Bool?
        func back(animated: Bool) {
            backCallCount += 1
            backAnimatedFlag = animated
        }
    }
}
