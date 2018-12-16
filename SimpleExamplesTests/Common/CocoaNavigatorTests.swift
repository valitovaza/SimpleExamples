import XCTest
@testable import SimpleExamples

class CocoaNavigatorTests: XCTestCase {

    private var sut: CocoaNavigator!
    private var innerNavigator: NavigatorMock!
    
    override func setUp() {
        innerNavigator = NavigatorMock()
        sut = CocoaNavigator(innerNavigator)
    }

    override func tearDown() {
        innerNavigator = nil
        sut = nil
    }
    
    func testOpenInvokesNavigatorsOpen() {
        let vc = UIViewController()
        try? sut.open(viewController: vc, animated: false)
        XCTAssertEqual(innerNavigator.openCallCount, 1)
        XCTAssertEqual(innerNavigator.opennedVc, vc)
        XCTAssertEqual(innerNavigator.openAnimatedFlag, false)
        
        XCTAssertEqual(innerNavigator.pushCallCount, 0)
        XCTAssertEqual(innerNavigator.backCallCount, 0)
        XCTAssertEqual(innerNavigator.addContentScreenCallCount, 0)
        XCTAssertEqual(innerNavigator.removeLastContentScreenCallCount, 0)
    }
    
    func testPushInvokesNavigatorsPush() {
        let vc = UIViewController()
        try? sut.push(viewController: vc, animated: true)
        XCTAssertEqual(innerNavigator.pushCallCount, 1)
        XCTAssertEqual(innerNavigator.pushedVc, vc)
        XCTAssertEqual(innerNavigator.pushAnimatedFlag, true)
        
        XCTAssertEqual(innerNavigator.openCallCount, 0)
        XCTAssertEqual(innerNavigator.backCallCount, 0)
        XCTAssertEqual(innerNavigator.addContentScreenCallCount, 0)
        XCTAssertEqual(innerNavigator.removeLastContentScreenCallCount, 0)
    }
    
    func testBackInvokesNavigatorsBack() {
        try? sut.open(viewController: UIViewController(), animated: false)
        try? sut.back(animated: false)
        XCTAssertEqual(innerNavigator.backCallCount, 1)
        XCTAssertEqual(innerNavigator.backAnimatedFlag, false)
        
        XCTAssertEqual(innerNavigator.pushCallCount, 0)
        XCTAssertEqual(innerNavigator.addContentScreenCallCount, 0)
        XCTAssertEqual(innerNavigator.removeLastContentScreenCallCount, 0)
    }
    
    func testAddContentScreenInvokesNavigatorsAddContentScreen() {
        let vc = UIViewController()
        try? sut.add(contentScreen: vc)
        XCTAssertEqual(innerNavigator.addContentScreenCallCount, 1)
        XCTAssertEqual(innerNavigator.addedVc, vc)
        
        XCTAssertEqual(innerNavigator.openCallCount, 0)
        XCTAssertEqual(innerNavigator.pushCallCount, 0)
        XCTAssertEqual(innerNavigator.backCallCount, 0)
        XCTAssertEqual(innerNavigator.removeLastContentScreenCallCount, 0)
    }
    
    func testRemoveLastContentScreenInvokesNavigatorsRemoveLastContentScreen() {
        try? sut.add(contentScreen: UIViewController())
        try? sut.removeLastContentScreen()
        XCTAssertEqual(innerNavigator.removeLastContentScreenCallCount, 1)
        
        XCTAssertEqual(innerNavigator.openCallCount, 0)
        XCTAssertEqual(innerNavigator.pushCallCount, 0)
        XCTAssertEqual(innerNavigator.backCallCount, 0)
    }
    
    func testOpenWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        XCTAssertThrowsError(try sut.open(viewController: UIViewController(),
                                          animated: true))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testPushWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantPush]
        XCTAssertThrowsError(try sut.push(viewController: UIViewController(),
                                          animated: true))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantPush)
        }
    }
    
    func testBackWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantNavigateBack]
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testAddContentScreenWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        XCTAssertThrowsError(try sut.add(contentScreen: UIViewController()))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
            NavigatorError.cantPresentAlreadyPresentedViewController)
        }
    }
    
    func testRemoveLastContentScreenWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantNavigateBack]
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testBackAfterOpenInvokesReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: vc, animated: false)
        try? sut.back(animated: true)
        XCTAssertEqual(vc.releaseDependenciesCallCount, 1)
    }
    
    func testBackWithoutPresentedVcThrowsAnError() {
        XCTAssertThrowsError(try sut.back(animated: false))
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testBackAfterOpenWithErrorDoesNotInvokesReleaseDependencies() {
        innerNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        let vc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: vc, animated: false)
        try? sut.back(animated: true)
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
    
    func testBackWithErrorDoesNotInvokesReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: vc, animated: false)
        innerNavigator.nextErrors = [.cantNavigateBack]
        try? sut.back(animated: true)
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
    
    func testBackAfterPushInvokesReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.push(viewController: vc, animated: false)
        try? sut.back(animated: true)
        XCTAssertEqual(vc.releaseDependenciesCallCount, 1)
    }
    
    func testBackAfterPushWithErrorDoesNotInvokesReleaseDependencies() {
        innerNavigator.nextErrors = [.cantPush]
        let vc = ViewControllerDependencyManagerMock()
        try? sut.push(viewController: vc, animated: false)
        try? sut.back(animated: true)
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
    
    func testRemoveLastContentScreenThrowsAnErrorIfNoAddedScreens() {
        try? sut.open(viewController: UIViewController(), animated: false)
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testRemoveAfterAddContentWithErrorThrowsAnError() {
        innerNavigator.nextErrors = [.cantPresentAlreadyPresentedViewController]
        try? sut.add(contentScreen: UIViewController())
        XCTAssertThrowsError(try sut.removeLastContentScreen())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testRemoveLastContentInvokesReleaseOnAllOpenedAndPushedVControllers() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.add(contentScreen: vc)
        let pushedVc = ViewControllerDependencyManagerMock()
        try? sut.push(viewController: pushedVc, animated: true)
        let openedVc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: openedVc, animated: false)
        try? sut.removeLastContentScreen()
        XCTAssertEqual(vc.releaseDependenciesCallCount, 1)
        XCTAssertEqual(pushedVc.releaseDependenciesCallCount, 1)
        XCTAssertEqual(openedVc.releaseDependenciesCallCount, 1)
    }
    
    func testRemoveLastWithErrorDoesNotInvokesReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.add(contentScreen: vc)
        innerNavigator.nextErrors = [.cantNavigateBack]
        try? sut.removeLastContentScreen()
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
    
    func testRemoveLastPresentedAfterPushInvokesReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.push(viewController: vc, animated: false)
        try? sut.removeLastPresentedViewController()
        XCTAssertEqual(vc.releaseDependenciesCallCount, 1)
    }
    
    func testRemoveLastPresentedAfterPushWithErrorDoesNotReleaseDependencies() {
        innerNavigator.nextErrors = [.cantPush]
        let vc = ViewControllerDependencyManagerMock()
        try? sut.push(viewController: vc, animated: false)
        try? sut.removeLastPresentedViewController()
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
    
    func testRemoveLastPresentedWithoutPresentedVcThrowsAnError() {
        XCTAssertThrowsError(try sut.removeLastPresentedViewController())
        { (error) in
            XCTAssertEqual(error as? NavigatorError,
                           NavigatorError.cantNavigateBack)
        }
    }
    
    func testRemoveLastPresentedInvokesNavigatorsRemoveLastPresented() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: vc, animated: false)
        try? sut.removeLastPresentedViewController()
        XCTAssertEqual(innerNavigator.removeLastPresentedViewControllerCallCount, 1)
    }
    
    func testRemoveLastPresentedWithErrorDoesNotReleaseDependencies() {
        let vc = ViewControllerDependencyManagerMock()
        try? sut.open(viewController: vc, animated: false)
        innerNavigator.nextErrors = [.cantNavigateBack]
        try? sut.removeLastPresentedViewController()
        XCTAssertEqual(vc.releaseDependenciesCallCount, 0)
    }
}
extension CocoaNavigatorTests {
    class ViewControllerDependencyManagerMock: UIViewController {
        var releaseDependenciesCallCount = 0
        override func releaseDependencies() {
            releaseDependenciesCallCount += 1
        }
    }
}
