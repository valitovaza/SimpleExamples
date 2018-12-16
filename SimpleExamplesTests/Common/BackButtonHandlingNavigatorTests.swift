import XCTest
@testable import SimpleExamples

class BackButtonHandlingNavigatorTests: XCTestCase {

    private var sut: BackButtonHandlingNavigator!
    private var factory: AggregatedManualNavigatorFactoryMock!
    private var initialVc: NavigationViewControllerMock!
    private var rootVc: UIViewController!
    private var navigator: NavigatorMock!
    
    override func setUp() {
        factory = AggregatedManualNavigatorFactoryMock()
        createNavigationController()
        sut = BackButtonHandlingNavigator(factory, initialVc)
        navigator = factory.navigator
    }
    private func createNavigationController() {
        initialVc = NavigationViewControllerMock()
        rootVc = UIViewController()
        initialVc.viewControllers = [rootVc]
    }

    override func tearDown() {
        factory = nil
        initialVc = nil
        rootVc = nil
        navigator = nil
        sut = nil
    }
    
    func testInitializationInvokesCreate() {
        XCTAssertEqual(factory.createCallCount, 1)
        XCTAssertEqual(factory.vc, initialVc)
    }
    
    func testOpenInvokesNavigatorsOpen() {
        let vc = UIViewController()
        try? sut.open(viewController: vc, animated: true)
        XCTAssertEqual(navigator.openCallCount, 1)
        XCTAssertEqual(navigator.opennedVc, vc)
        XCTAssertEqual(navigator.openAnimatedFlag, true)
        
        XCTAssertEqual(navigator.pushCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testOpenWithErrorThrowsAnError() {
        navigator.nextErrors = [.cantPushAlert]
        XCTAssertThrowsError(try sut.open(viewController: UIViewController(),
                                          animated: true))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantPushAlert)
        }
    }
    
    func testPushInvokesNavigatorsPush() {
        let vc = UIViewController()
        try? sut.push(viewController: vc, animated: false)
        XCTAssertEqual(navigator.pushCallCount, 1)
        XCTAssertEqual(navigator.pushedVc, vc)
        XCTAssertEqual(navigator.pushAnimatedFlag, false)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testPushWithErrorThrowsAnError() {
        navigator.nextErrors = [.cantPushAlert]
        XCTAssertThrowsError(try sut.push(viewController: UIViewController(),
                                          animated: true))
        { (error) in
            XCTAssertEqual(error as? NavigatorError, NavigatorError.cantPushAlert)
        }
    }
    
    func testBackInvokesNavigatorsBack() {
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.back(animated: false)
        XCTAssertEqual(navigator.backCallCount, 1)
        XCTAssertEqual(navigator.backAnimatedFlag, false)
        
        XCTAssertEqual(navigator.pushCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testBackWithErrorThrowsAnError() {
        try? sut.open(viewController: UIViewController(), animated: false)
        navigator.nextErrors = [.cantNavigateBack]
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testPushMustIgnoreNextDidShow() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        sut.navigationController(UINavigationController(), didShow: pushedVc, animated: false)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testDidShowInvokesRemoveLastAfterPresentingCurrentPushedAndPrevious() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    private func performDidShow(current: UIViewController,
                                then previous: UIViewController) {
        let nav = UINavigationController()
        sut.navigationController(nav, didShow: current, animated: false)
        sut.navigationController(nav, didShow: previous, animated: false)
    }
    
    func testPushAndDidShowWithRootViewControllerInvokesRemoveLastPresented() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: rootVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testDidShowMustBeIgnoredIfViewControllerHasNotBeenPushed() {
        performDidShow(current: UIViewController(), then: UIViewController())
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testDidShowInvokesRemoveLastMultipleTimes() {
        let pushedVc0 = UIViewController()
        try? sut.push(viewController: pushedVc0, animated: false)
        let pushedVc1 = UIViewController()
        try? sut.push(viewController: pushedVc1, animated: true)
        performDidShow(current: pushedVc1, then: pushedVc0)
        performDidShow(current: pushedVc0, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 2)
    }
    
    func testDidShowMustBeIgnoredIfViewControllerIsNotPreviousPresented() {
        let pushedVc0 = UIViewController()
        try? sut.push(viewController: pushedVc0, animated: false)
        let pushedVc1 = UIViewController()
        try? sut.push(viewController: pushedVc1, animated: true)
        performDidShow(current: pushedVc0, then: pushedVc1)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testPushErrorMustNotAffectToDidShow() {
        navigator.nextErrors = [.cantPush]
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testBackMustMakeRemoveLastIgnored() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        try? sut.back(animated: true)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testBackWithErrorDoesNotAffectRemoveLast() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        navigator.nextErrors = [.cantNavigateBack]
        try? sut.back(animated: true)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testPush_OpenWithError_Back_MustMakeRemoveLastIgnored() {
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.back(animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testOpenedVControllerCannotBeRemoved() {
        let openedVc = UIViewController()
        try? sut.open(viewController: openedVc, animated: false)
        performDidShow(current: openedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 0)
    }
    
    func testBackWithNoPresentedVControllersThrowsAnError() {
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testOpenThenBackMustReleaseOpenedVc() {
        var openedVc: UIViewController? = UIViewController()
        weak var weakVc = openedVc
        try? sut.open(viewController: openedVc!, animated: false)
        try? sut.back(animated: false)
        
        navigator.pushedVc = nil
        navigator.opennedVc = nil
        openedVc = nil
        
        XCTAssertNil(weakVc)
    }
    
    func testAddContentInvokesNavigatorsAddContent() {
        let vc = UIViewController()
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(navigator.addContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addedVc, vc)
    }
    
    func testAddContentWithErrorThrowsAnError() {
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        XCTAssertThrowsError(try sut.add(contentScreen: UIViewController()))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testRemoveLastContentInvokesNavigatorsRemoveLastContent() {
        try? sut.removeLastContentScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
    }
    
    func testRemoveLastContentWithErrorThrowsAnError() {
        navigator.nextErrors = [.cantNavigateBack]
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testAddContentScreenSetDelegateIfContentIsNavigationController() {
        let nav = UINavigationController()
        try? sut.add(contentScreen: nav)
        XCTAssertTrue(nav.delegate === sut)
    }
    
    func testAddContentDoesNotSetDelegateIfError() {
        let nav = UINavigationController()
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        try? sut.add(contentScreen: nav)
        XCTAssertFalse(nav.delegate === sut)
    }
    
    func testAddContent_Push_DidShowInvokesRemoveLastPresented() {
        let nav = NavigationViewControllerMock()
        try? sut.add(contentScreen: nav)
        let pushedVc = ViewControllerMock()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: nav)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testAddContentWithError_Push_DidShowInvokesRemoveLastPresented() {
        let nav = NavigationViewControllerMock()
        navigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        try? sut.add(contentScreen: nav)
        let pushedVc = ViewControllerMock()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testRemoveLastContentScreenChangeTopViewController() {
        let nav = NavigationViewControllerMock()
        try? sut.add(contentScreen: nav)
        try? sut.removeLastContentScreen()
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testRemoveLastContentWithErrorDoesNotChangeTopViewController() {
        let nav = NavigationViewControllerMock()
        try? sut.add(contentScreen: nav)
        navigator.nextErrors = [.cantNavigateBack]
        try? sut.removeLastContentScreen()
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: nav)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testRemoveLastContentMustRemoveAddRelatedPushedOrOpenedVControllers() {
        let nav = NavigationViewControllerMock()
        try? sut.add(contentScreen: nav)
        try? sut.push(viewController: UIViewController(), animated: false)
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.removeLastContentScreen()
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        performDidShow(current: pushedVc, then: initialVc)
        XCTAssertEqual(navigator.removeLastPresentedViewControllerCallCount, 1)
    }
}
extension BackButtonHandlingNavigatorTests {
    class AggregatedManualNavigatorFactoryMock: AggregatedManualNavigatorFactory {
        var createCallCount = 0
        var vc: UIViewController?
        var navigators: [NavigatorMock] = []
        func create(_ vc: UIViewController) -> AggregatedManualNavigator {
            createCallCount += 1
            self.vc = vc
            let navigator = NavigatorMock()
            navigators.append(navigator)
            return navigator
        }
        var navigator: NavigatorMock {
            return navigators.last!
        }
    }
}
