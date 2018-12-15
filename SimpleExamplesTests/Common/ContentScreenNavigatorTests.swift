import XCTest
@testable import SimpleExamples

class ContentScreenNavigatorTests: XCTestCase {

    private var sut: ContentScreenNavigatorImpl!
    private var navigatorFactory: NavigatorFactorySpy!
    private var initialNavigator: NavigatorMock!
    
    private let initialVc = ContentChildControllerMock()
    
    override func setUp() {
        navigatorFactory = NavigatorFactorySpy()
        sut = ContentScreenNavigatorImpl(initialVc, navigatorFactory)
        initialNavigator = navigatorFactory.createdNavigators.first!
    }

    override func tearDown() {
        navigatorFactory = nil
        sut = nil
    }
    
    func testSutInitializationMustCreateNavigatorWithInitialVc() {
        XCTAssertEqual(navigatorFactory.createVc, initialVc)
    }
    
    func testOpenViewControllerInvokesInitialNavigatorsOpen() {
        let nextVc = UIViewController()
        try? sut.open(viewController: nextVc, animated: false)
        XCTAssertEqual(initialNavigator.openCallCount, 1)
        XCTAssertEqual(initialNavigator.opennedVc, nextVc)
        XCTAssertEqual(initialNavigator.openAnimatedFlag, false)
        
        XCTAssertEqual(initialNavigator.pushCallCount, 0)
        XCTAssertEqual(initialNavigator.backCallCount, 0)
    }
    
    func testPushViewControllerInvokesInitialNavigatorsPush() {
        let nextVc = UIViewController()
        try? sut.push(viewController: nextVc, animated: true)
        XCTAssertEqual(initialNavigator.pushCallCount, 1)
        XCTAssertEqual(initialNavigator.pushedVc, nextVc)
        XCTAssertEqual(initialNavigator.pushAnimatedFlag, true)
        
        XCTAssertEqual(initialNavigator.openCallCount, 0)
        XCTAssertEqual(initialNavigator.backCallCount, 0)
    }
    
    func testBackInvokesInitialNavigatorsBack() {
        try? sut.back(animated: false)
        XCTAssertEqual(initialNavigator.backCallCount, 1)
        XCTAssertEqual(initialNavigator.backAnimatedFlag, false)
        
        XCTAssertEqual(initialNavigator.openCallCount, 0)
        XCTAssertEqual(initialNavigator.pushCallCount, 0)
    }
    
    func testAddContentScreenCreatesNavigatorWithTopViewController() {
        let vc = UIViewController()
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(navigatorFactory.createCallCount, 2)
        XCTAssertEqual(navigatorFactory.createVc, vc)
        XCTAssertEqual(navigatorFactory.createdNavigators.count, 2)
    }
    
    func testOpenViewControllerAfterAddContentMustUseNewNavigator() {
        try? sut.add(contentScreen: UIViewController())
        try? sut.open(viewController: UIViewController(), animated: true)
        XCTAssertEqual(navigatorFactory.currentNavigator.openCallCount, 1)
        XCTAssertEqual(navigatorFactory.currentNavigator.openAnimatedFlag, true)
    }
    
    func testPushViewControllerAfterAddContentMustUseNewNavigator() {
        try? sut.add(contentScreen: UIViewController())
        try? sut.push(viewController: UIViewController(), animated: false)
        XCTAssertEqual(navigatorFactory.currentNavigator.pushCallCount, 1)
        XCTAssertEqual(navigatorFactory.currentNavigator.pushAnimatedFlag, false)
    }
    
    func testBackAfterAddContentMustUseNewNavigator() {
        try? sut.add(contentScreen: UIViewController())
        try? sut.back(animated: true)
        XCTAssertEqual(navigatorFactory.currentNavigator.backCallCount, 1)
        XCTAssertEqual(navigatorFactory.currentNavigator.backAnimatedFlag, true)
    }
    
    func testAddContentScreenInvokesAddContentChild() {
        let vc = UIViewController()
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(initialVc.addContentChildCallCount, 1)
    }
    
    func testOpenWithNavigationErrorMustThrowSameError() {
        initialNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        XCTAssertThrowsError(try sut.open(viewController: UIViewController(),
                                          animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testPushWithNavigationErrorMustThrowSameError() {
        initialNavigator.nextErrors = [.cantPush]
        XCTAssertThrowsError(try sut.push(viewController: UIViewController(),
                                          animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPush)
        }
    }
    
    func testBackWithNavigationErrorMustThrowSameError() {
        initialNavigator.nextErrors = [.cantNavigateBack]
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testAddContentScreenThatIsAlreadyAddedMustThrowAnError() {
        let vc0 = UIViewController()
        try? sut.add(contentScreen: vc0)
        let vc1 = UIViewController()
        try? sut.add(contentScreen: vc1)
        XCTAssertThrowsError(try sut.add(contentScreen: vc0))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
        XCTAssertThrowsError(try sut.add(contentScreen: vc1))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testAddInitialViewControllerAsContentScreenMustThrowAnError() {
        XCTAssertThrowsError(try sut.add(contentScreen: initialVc))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testAddContentSecondTimeMustAddChildToFirstViewController() {
        let vc0 = ContentChildControllerMock()
        try? sut.add(contentScreen: vc0)
        let vc1 = ContentChildControllerMock()
        try? sut.add(contentScreen: vc1)
        XCTAssertEqual(vc0.addContentChildCallCount, 1)
        XCTAssertEqual(vc0.addedVc, vc1)
    }
    
    func testAddContent2TimesThenOpenMustBeInvokedOn3rdNavigation() {
        try? sut.add(contentScreen: UIViewController())
        try? sut.add(contentScreen: UIViewController())
        try? sut.open(viewController: UIViewController(), animated: true)
        XCTAssertEqual(navigatorFactory.currentNavigator.openCallCount, 1)
    }
    
    func testAddContentThenOpenThenAddContentMustAddChildToOpenedVc() {
        try? sut.add(contentScreen: UIViewController())
        let openedVc = ContentChildControllerMock()
        try? sut.open(viewController: openedVc, animated: false)
        let addVc = UIViewController()
        try? sut.add(contentScreen: addVc)
        XCTAssertEqual(openedVc.addContentChildCallCount, 1)
        XCTAssertEqual(openedVc.addedVc, addVc)
    }
    
    func testCanNotAddOpenedViewController_thowsAnError() {
        let vc = UIViewController()
        try? sut.open(viewController: vc, animated: false)
        XCTAssertThrowsError(try sut.add(contentScreen: vc))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testOpenWithErrorMustNotAffectToNextAddition() {
        initialNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        let vc = UIViewController()
        try? sut.open(viewController: vc, animated: false)
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(navigatorFactory.createCallCount, 2)
    }
    
    func testAddContentThenPushThenAddContentMustAddChildToPushedVc() {
        try? sut.add(contentScreen: UIViewController())
        let pushedVc = ContentChildControllerMock()
        try? sut.push(viewController: pushedVc, animated: true)
        let addVc = UIViewController()
        try? sut.add(contentScreen: addVc)
        XCTAssertEqual(pushedVc.addContentChildCallCount, 1)
        XCTAssertEqual(pushedVc.addedVc, addVc)
    }
    
    func testCanNotAddPushedViewController_thowsAnError() {
        let vc = UIViewController()
        try? sut.push(viewController: vc, animated: true)
        XCTAssertThrowsError(try sut.add(contentScreen: vc))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testPushWithErrorMustNotAffectToNextAddition() {
        initialNavigator.nextErrors = [.cantPush]
        let vc = UIViewController()
        try? sut.push(viewController: vc, animated: false)
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(navigatorFactory.createCallCount, 2)
    }
    
    func testOpenThenBackThenAddContentMustUseInitialVc() {
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.back(animated: true)
        try? sut.add(contentScreen: UIViewController())
        XCTAssertEqual(initialVc.addContentChildCallCount, 1)
    }
    
    func testPushThenBackThenAddContentMustUseInitialVc() {
        try? sut.push(viewController: UIViewController(), animated: false)
        try? sut.back(animated: true)
        try? sut.add(contentScreen: UIViewController())
        XCTAssertEqual(initialVc.addContentChildCallCount, 1)
    }
    
    func testBackErrorMustNotAffectToAdditionOfContentScreen() {
        let vc = ContentChildControllerMock()
        try? sut.push(viewController: vc, animated: false)
        initialNavigator.nextErrors = [.cantNavigateBack]
        try? sut.back(animated: true)
        let nextVc = UIViewController()
        try? sut.add(contentScreen: nextVc)
        XCTAssertEqual(vc.addContentChildCallCount, 1)
        XCTAssertEqual(vc.addedVc, nextVc)
    }
    
    func testRemoveLastContentScreenInvokesRemoveContentChild() {
        let vc = ContentChildControllerMock()
        try? sut.add(contentScreen: vc)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(initialVc.removeContentChildCallCount, 1)
        XCTAssertEqual(initialVc.removedVc, vc)
    }
    
    func testRemoveLastContentIfNoAddedThrowsAnError() {
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testRemoveLastWithoutAddingAndAfterOpeningThrowsAnError() {
        let vc = ContentChildControllerMock()
        try? sut.open(viewController: vc, animated: true)
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testRemoveLastWithoutAddingAndAfterPushingThrowsAnError() {
        let vc = ContentChildControllerMock()
        try? sut.push(viewController: vc, animated: true)
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testPushThenAddContentThenRemoveLastInvokesRemoveContentOnPushedVc() {
        let pushedVc = ContentChildControllerMock()
        try? sut.push(viewController: pushedVc, animated: true)
        let newContentVc = UIViewController()
        try? sut.add(contentScreen: newContentVc)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(pushedVc.removeContentChildCallCount, 1)
        XCTAssertEqual(pushedVc.removedVc, newContentVc)
    }
    
    func testAddContentThenOpenThenRemoveLastMustRemoveAddedContentVc() {
        let newContentVc = UIViewController()
        try? sut.add(contentScreen: newContentVc)
        try? sut.push(viewController: UIViewController(), animated: true)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(initialVc.removedVc, newContentVc)
    }
    
    func testPush_Open_AddContent_Push_Open_RemoveLastContent_Open() {
        try? sut.push(viewController: UIViewController(), animated: true)
        let openedVc = ContentChildControllerMock()
        try? sut.open(viewController: openedVc, animated: false)
        try? sut.add(contentScreen: UIViewController())
        XCTAssertEqual(openedVc.addContentChildCallCount, 1)
        try? sut.push(viewController: UIViewController(), animated: true)
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.removeLastContentScreen()
        let opennedVc1 = UIViewController()
        try? sut.open(viewController: opennedVc1, animated: false)
        XCTAssertEqual(initialNavigator.opennedVc, opennedVc1)
    }
    
    func testRemoveLastContent2Times() {
        let vc0 = ContentChildControllerMock()
        try? sut.add(contentScreen: vc0)
        let vc1 = ContentChildControllerMock()
        try? sut.add(contentScreen: vc1)
        XCTAssertEqual(vc0.addContentChildCallCount, 1)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(vc0.removeContentChildCallCount, 1)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(initialVc.removeContentChildCallCount, 1)
    }
    
    func testAddContent_Push_Remove_PushAgain() {
        try? sut.add(contentScreen: UIViewController())
        let pushedVc = UIViewController()
        try? sut.push(viewController: pushedVc, animated: false)
        try? sut.removeLastContentScreen()
        try? sut.push(viewController: pushedVc, animated: true)
        XCTAssertEqual(initialNavigator.pushCallCount, 1)
        XCTAssertEqual(initialNavigator.pushedVc, pushedVc)
    }
    
    func testRemoveContentMustReleaseReferences() {
        try? sut.add(contentScreen: UIViewController())
        var openedVc: UIViewController? = UIViewController()
        weak var weakVc = openedVc
        try? sut.open(viewController: openedVc!, animated: true)
        try? sut.removeLastContentScreen()
        
        navigatorFactory.createdNavigators = []
        initialVc.addedVc = nil
        initialVc.removedVc = nil
        navigatorFactory.createVc = nil
        openedVc = nil
        
        XCTAssertNil(weakVc)
    }
}
extension ContentScreenNavigatorTests {
    class NavigatorFactorySpy: NavigatorFactory {
        var createCallCount = 0
        var createVc: UIViewController?
        var createdNavigators: [NavigatorMock] = []
        func create(_ viewController: UIViewController) -> Navigator {
            createCallCount += 1
            createVc = viewController
            let navigator = NavigatorMock()
            createdNavigators.append(navigator)
            return navigator
        }
        var currentNavigator: NavigatorMock {
            return createdNavigators.last!
        }
    }
    class ContentChildControllerMock: UIViewController {
        var addContentChildCallCount = 0
        var addedVc: UIViewController?
        override func addContentChild(viewController: UIViewController) {
            super.addContentChild(viewController: viewController)
            addedVc = viewController
            addContentChildCallCount += 1
        }
        
        var removeContentChildCallCount = 0
        var removedVc: UIViewController?
        override func removeContentChild(viewController: UIViewController) {
            super.removeContentChild(viewController: viewController)
            removeContentChildCallCount += 1
            removedVc = viewController
        }
    }
}
