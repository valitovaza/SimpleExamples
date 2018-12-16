import XCTest
@testable import SimpleExamples

class AggregatedManualNavigatorFactoryTests: XCTestCase {

    private var sut: ContentScreenNavigatorFactoryImpl!
    private var factory: ManualBackNavigatorFactorySpy!
    
    override func setUp() {
        factory = ManualBackNavigatorFactorySpy()
        sut = ContentScreenNavigatorFactoryImpl(factory)
    }

    override func tearDown() {
        factory = nil
        sut = nil
    }
    
    func testCreatedNavigatorIsNavigatorImpl() {
        XCTAssertTrue(sut.create(UIViewController()) is CocoaNavigator)
    }
    
    func testCreateUseSentViewController() {
        let vc = ViewControllerMock()
        _ = sut.create(vc)
        XCTAssertEqual(factory.createCallCount, 1)
        XCTAssertEqual(factory.createVc, vc)
    }
}
