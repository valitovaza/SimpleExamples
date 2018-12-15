import XCTest
@testable import SimpleExamples

class MainRouterTests: XCTestCase {
    
    private var sut: MainRouter!
    private var navigator: ErrorHandlingNavigatorSpy!
    
    private let loadingVc = UIViewController()
    private let contentVc = UIViewController()
    private let loginVC = UIViewController()
    
    override func setUp() {
        navigator = ErrorHandlingNavigatorSpy()
        sut = MainRouter(navigator,
                         {self.loadingVc},
                         {self.contentVc},
                         {self.loginVC})
    }
    
    override func tearDown() {
        navigator = nil
        sut = nil
    }
    
    func testOpenLoadingScreenInvokesSetContent() {
        sut.openLoadingScreen()
        XCTAssertEqual(navigator.addContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addedVc, loadingVc)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.pushCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testOpenContentScreenInvokesSetContent() {
        sut.openContentScreen()
        XCTAssertEqual(navigator.addContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addedVc, contentVc)
        
        XCTAssertEqual(navigator.openCallCount, 0)
        XCTAssertEqual(navigator.pushCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testOpenLoginScreenInvokesNavigatorOpen() {
        sut.openLoginScreen()
        XCTAssertEqual(navigator.openCallCount, 1)
        XCTAssertEqual(navigator.opennedVc, loginVC)
        XCTAssertEqual(navigator.openAnimatedFlag, true)
        
        XCTAssertEqual(navigator.pushCallCount, 0)
        XCTAssertEqual(navigator.backCallCount, 0)
        XCTAssertEqual(navigator.addContentScreenCallCount, 0)
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
    
    func testOpenLoadingSecondTimeInvokesRemoveContent() {
        sut.openLoadingScreen()
        sut.openLoadingScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addContentScreenCallCount, 2)
    }
    
    func testOpenLoadingSecondTimeInvokesRemoveContentBeforeAdding() {
        sut.openLoadingScreen()
        navigator.removeLastContentInterceptionCallback = {[unowned self] in
            XCTAssertEqual(self.navigator.addContentScreenCallCount, 1)
        }
        sut.openLoadingScreen()
    }
    
    func testOpenContentScreenSecondTimeInvokesRemoveContent() {
        sut.openContentScreen()
        sut.openContentScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addContentScreenCallCount, 2)
    }
    
    func testOpenContentScreenSecondTimeInvokesRemoveContentBeforeAdding() {
        sut.openContentScreen()
        navigator.removeLastContentInterceptionCallback = {[unowned self] in
            XCTAssertEqual(self.navigator.addContentScreenCallCount, 1)
        }
        sut.openContentScreen()
    }
    
    func testOpenContentThenOpenLoadingScreenInvokesremoveContent() {
        sut.openContentScreen()
        sut.openLoadingScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addContentScreenCallCount, 2)
    }
    
    func testOpenLoadingThenOpenContentScreenInvokesremoveContent() {
        sut.openLoadingScreen()
        sut.openContentScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 1)
        XCTAssertEqual(navigator.addContentScreenCallCount, 2)
    }
    
    func testOpenLoginScreenThenOpenContentScreenDoesNotInvokesRemove() {
        sut.openLoginScreen()
        sut.openContentScreen()
        XCTAssertEqual(navigator.removeLastContentScreenCallCount, 0)
    }
}
