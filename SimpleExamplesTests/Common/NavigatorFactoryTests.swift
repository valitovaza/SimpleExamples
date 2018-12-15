import XCTest
@testable import SimpleExamples

class NavigatorFactoryTests: XCTestCase {

    private var sut: NavigatorFactoryImpl!
    
    override func setUp() {
        sut = NavigatorFactoryImpl()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testCreateNavigatorImpl() {
        XCTAssertTrue(sut.create(UIViewController()) is NavigatorImpl)
    }
    
    func testCreateUseSentViewControllerToCreateNavigator() {
        let vc = ViewControllerMock()
        let navigator = sut.create(vc)
        try? navigator.open(viewController: UIViewController(), animated: false)
        XCTAssertEqual(vc.presentCallCount, 1)
    }
}
