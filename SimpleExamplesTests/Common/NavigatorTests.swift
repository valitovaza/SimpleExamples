import XCTest
@testable import SimpleExamples

class NavigatorTests: XCTestCase {

    private var sut: NavigatorImpl!
    private var navSut: NavigatorImpl!
    private var initialVc: ViewControllerMock!
    private var initialNavigationVc: NavigationViewControllerMock!
    
    override func setUp() {
        initialVc = ViewControllerMock()
        initialNavigationVc = NavigationViewControllerMock()
        sut = NavigatorImpl(initialVc)
        navSut = NavigatorImpl(initialNavigationVc)
    }

    override func tearDown() {
        initialVc = nil
        initialNavigationVc = nil
        sut = nil
        navSut = nil
    }
    
    func testOpenInvokesPresentViewController() {
        let nextVc = UIViewController()
        try? sut.open(viewController: nextVc, animated: false)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        XCTAssertEqual(initialVc.presentedVc, nextVc)
        XCTAssertEqual(initialVc.presentAnimatedFlag, false)
        XCTAssertEqual(initialVc.dismissCallCount, 0)
    }
    
    func testOpenMustChangeNextPresenterViewController() {
        let nextVc0 = ViewControllerMock()
        try? sut.open(viewController: nextVc0, animated: true)
        let nextVc1 = UIViewController()
        try? sut.open(viewController: nextVc1, animated: true)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        XCTAssertEqual(nextVc0.presentCallCount, 1)
        XCTAssertEqual(nextVc0.presentedVc, nextVc1)
        XCTAssertEqual(nextVc0.presentAnimatedFlag, true)
    }
    
    func testBackMustDismissLastPresentedViewController() {
        let nextVc = ViewControllerMock()
        try? sut.open(viewController: nextVc, animated: false)
        try? sut.back(animated: false)
        XCTAssertEqual(nextVc.dismissCallCount, 1)
        XCTAssertEqual(nextVc.dismissAnimatedFlag, false)
        XCTAssertEqual(initialVc.dismissCallCount, 0)
    }
    
    func testBackThrowsAnErrorIfOnlyInitialVcPresented() {
        XCTAssertThrowsError(try sut.back(animated: true)) { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testOpenAnd2Back() {
        let nextVc = ViewControllerMock()
        try? sut.open(viewController: nextVc, animated: true)
        try? sut.back(animated: true)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        XCTAssertEqual(nextVc.dismissCallCount, 1)
        XCTAssertEqual(nextVc.dismissAnimatedFlag, true)
        XCTAssertThrowsError(try sut.back(animated: false)) { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func test2OpenAnd2BackActions() {
        let nextVc0 = ViewControllerMock()
        try? sut.open(viewController: nextVc0, animated: false)
        let nextVc1 = ViewControllerMock()
        try? sut.open(viewController: nextVc1, animated: true)
        try? sut.back(animated: true)
        XCTAssertEqual(nextVc0.dismissCallCount, 0)
        XCTAssertEqual(nextVc1.dismissCallCount, 1)
        
        try? sut.back(animated: false)
        XCTAssertEqual(nextVc0.dismissCallCount, 1)
        XCTAssertEqual(nextVc1.dismissCallCount, 1)
    }
    
    func testPushMustThowAnErrorIfInitialIsNotUINavigationController() {
        XCTAssertThrowsError(try sut.push(viewController: UIViewController(), animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantPush)
        }
    }
    
    func testPushMustPushViewControllerIfInitialIsUINavigationController() {
        let nextVc = UIViewController()
        try? navSut.push(viewController: nextVc, animated: true)
        XCTAssertEqual(initialNavigationVc.pushViewControllerCallCount, 1)
        XCTAssertEqual(initialNavigationVc.pushAnimationFlag, true)
        XCTAssertEqual(initialNavigationVc.pushedViewController, nextVc)
    }
    
    func testPushAnimationMustAffectPushViewController() {
        try? navSut.push(viewController: UIViewController(), animated: false)
        XCTAssertEqual(initialNavigationVc.pushAnimationFlag, false)
    }
    
    func testPushUIAlertControllerMustThowAnError() {
        XCTAssertThrowsError(try navSut.push(viewController: UIAlertController(),
                                             animated: true))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantPushAlert)
        }
    }
    
    func testOpenAlreadyOpenedScreenMustThrowAnError() {
        let nextVc = UIViewController()
        try? sut.open(viewController: nextVc, animated: false)
        XCTAssertThrowsError(try sut.open(viewController: nextVc,
                                      animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testOpenInitialScreenMustThrowAnError() {
        XCTAssertThrowsError(try sut.open(viewController: initialVc,
                                          animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testPushAlreadyPresentedScreenMustThrowAnError() {
        let nextVc = UIViewController()
        try? navSut.push(viewController: nextVc, animated: true)
        XCTAssertThrowsError(try navSut.push(viewController: nextVc,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testPushInitialViewControllerMustThrowAnError() {
        XCTAssertThrowsError(try navSut.push(viewController: initialNavigationVc,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testOpenAlreadyPushedViewControllerMustThrowAnError() {
        let nextVc = UIViewController()
        try? navSut.push(viewController: nextVc, animated: true)
        XCTAssertThrowsError(try navSut.open(viewController: nextVc,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testBackOnNavSutMustInvokePopViewController() {
        let nextVc = ViewControllerMock()
        try? navSut.push(viewController: nextVc, animated: false)
        try? navSut.back(animated: false)
        XCTAssertEqual(initialNavigationVc.popViewControllerCallCount, 1)
        XCTAssertEqual(initialNavigationVc.popAnimationFlag, false)
        XCTAssertEqual(nextVc.dismissCallCount, 0)
    }
    
    func testBackOnNavSutMustThrowAnErrorIfNoPushedViewControllers() {
        XCTAssertThrowsError(try navSut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantNavigateBack)
        }
        XCTAssertEqual(initialNavigationVc.popViewControllerCallCount, 0)
    }
    
    func testPushAndBack2TimesMustThrowAnError() {
        let nextVc = ViewControllerMock()
        try? navSut.push(viewController: nextVc, animated: false)
        try? navSut.back(animated: true)
        XCTAssertEqual(initialNavigationVc.popAnimationFlag, true)
        XCTAssertThrowsError(try navSut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantNavigateBack)
        }
    }
    
    func testPushThenOpenThenPushInvokesPushOnSecondNavigation() {
        let pushedVc = ViewControllerMock()
        try? navSut.push(viewController: pushedVc, animated: false)
        let secondNav = NavigationViewControllerMock()
        try? navSut.open(viewController: secondNav, animated: true)
        try? navSut.push(viewController: UIViewController(), animated: false)
        XCTAssertEqual(secondNav.pushViewControllerCallCount, 1)
        XCTAssertEqual(initialNavigationVc.pushViewControllerCallCount, 1)
    }
    
    func testPushAfterOpeningNotUINavigationViewControllerMustThrowAnError() {
        let nextVc = UIViewController()
        try? navSut.open(viewController: nextVc, animated: true)
        XCTAssertThrowsError(try navSut.push(viewController: nextVc,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantPush)
        }
    }
    
    func testPushAlreadyOpenedScreenMustThrowAnError() {
        let nextNav = NavigationViewControllerMock()
        try? navSut.open(viewController: nextNav, animated: true)
        XCTAssertThrowsError(try navSut.push(viewController: nextNav,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testCanNotPushUINavigationViewController() {
        let nextNav = NavigationViewControllerMock()
        XCTAssertThrowsError(try navSut.push(viewController: nextNav,
                                             animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPushNavigationViewController)
        }
    }
    
    func testBackAfterPushThenOpenThenPush() {
        let pushedVc = ViewControllerMock()
        try? navSut.push(viewController: pushedVc, animated: false)
        let secondNav = NavigationViewControllerMock()
        try? navSut.open(viewController: secondNav, animated: true)
        try? navSut.push(viewController: UIViewController(), animated: false)
        try? navSut.back(animated: false)
        XCTAssertEqual(secondNav.popViewControllerCallCount, 1)
        XCTAssertEqual(secondNav.popAnimationFlag, false)
        XCTAssertEqual(secondNav.dismissCallCount, 0)
        
        try? navSut.back(animated: true)
        XCTAssertEqual(secondNav.dismissCallCount, 1)
        XCTAssertEqual(secondNav.dismissAnimatedFlag, true)
        XCTAssertEqual(initialNavigationVc.popViewControllerCallCount, 0)
        
        try? navSut.back(animated: true)
        XCTAssertEqual(initialNavigationVc.popViewControllerCallCount, 1)
        XCTAssertEqual(initialNavigationVc.popAnimationFlag, true)
        
        XCTAssertThrowsError(try navSut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantNavigateBack)
        }
    }
    
    func test2TimesOpen_2TimesPush_ThenOpen() {
        let nextVc0 = ViewControllerMock()
        try? sut.open(viewController: nextVc0, animated: false)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        
        let nextVc1 = NavigationViewControllerMock()
        try? sut.open(viewController: nextVc1, animated: true)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        XCTAssertEqual(nextVc1.pushViewControllerCallCount, 0)
        
        let nextVc2 = ViewControllerMock()
        try? sut.push(viewController: nextVc2, animated: false)
        XCTAssertEqual(nextVc1.pushViewControllerCallCount, 1)
        
        let nextVc3 = ViewControllerMock()
        try? sut.push(viewController: nextVc3, animated: true)
        XCTAssertEqual(nextVc1.pushViewControllerCallCount, 2)
        
        let nextVc4 = ViewControllerMock()
        try? sut.open(viewController: nextVc4, animated: false)
        XCTAssertEqual(nextVc3.presentCallCount, 1)
        XCTAssertEqual(nextVc3.presentedVc, nextVc4)
        
        XCTAssertEqual(nextVc1.pushViewControllerCallCount, 2)
        XCTAssertEqual(nextVc1.presentCallCount, 0)
        XCTAssertEqual(initialVc.presentCallCount, 1)
        XCTAssertEqual(nextVc0.presentCallCount, 1)
        XCTAssertEqual(nextVc2.presentCallCount, 0)
    }
    
    func test2TimesOpen_Push_ThenBack_ThenOpen() {
        let nextVc0 = ViewControllerMock()
        try? sut.open(viewController: nextVc0, animated: false)
        let nextVc1 = NavigationViewControllerMock()
        try? sut.open(viewController: nextVc1, animated: true)
        let nextVc2 = ViewControllerMock()
        try? sut.push(viewController: nextVc2, animated: false)
        let nextVc3 = ViewControllerMock()
        try? sut.push(viewController: nextVc3, animated: true)
        let nextVc4 = ViewControllerMock()
        try? sut.open(viewController: nextVc4, animated: false)
        
        try? sut.back(animated: false)
        XCTAssertEqual(nextVc4.dismissCallCount, 1)
        XCTAssertEqual(nextVc1.popViewControllerCallCount, 0)
        
        try? sut.back(animated: true)
        XCTAssertEqual(nextVc1.popViewControllerCallCount, 1)
        
        try? sut.back(animated: false)
        XCTAssertEqual(nextVc1.popViewControllerCallCount, 2)
        XCTAssertEqual(nextVc1.dismissCallCount, 0)
        
        try? sut.back(animated: false)
        XCTAssertEqual(nextVc1.dismissCallCount, 1)
        XCTAssertEqual(nextVc0.dismissCallCount, 0)
        
        try? sut.back(animated: true)
        XCTAssertEqual(nextVc0.dismissCallCount, 1)
        
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantNavigateBack)
        }
    }
}
extension NavigatorTests {
    class NavigationViewControllerMock: UINavigationController {
        var pushViewControllerCallCount = 0
        var pushAnimationFlag: Bool?
        var pushedViewController: UIViewController?
        override func pushViewController(_ viewController: UIViewController,
                                         animated: Bool) {
            pushAnimationFlag = animated
            pushedViewController = viewController
            pushViewControllerCallCount += 1
        }
        
        var popViewControllerCallCount = 0
        var popAnimationFlag: Bool?
        override func popViewController(animated: Bool) -> UIViewController? {
            popAnimationFlag = animated
            popViewControllerCallCount += 1
            return nil
        }
        
        var presentCallCount = 0
        override func present(_ viewControllerToPresent: UIViewController,
                              animated flag: Bool,
                              completion: (() -> Void)? = nil) {
            presentCallCount += 1
        }
        
        var dismissCallCount = 0
        var dismissAnimatedFlag: Bool?
        var dismissCompletion: (() -> Void)?
        override func dismiss(animated flag: Bool,
                              completion: (() -> Void)? = nil) {
            dismissCallCount += 1
            dismissAnimatedFlag = flag
            dismissCompletion = completion
        }
    }
}
