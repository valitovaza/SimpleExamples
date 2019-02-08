import XCTest
import Core

class ContentFetchAdaptersTests: XCTestCase {
    func testGetContentFromCounterRepositoryReturnValue() {
        let sut = CounterRepositoryImpl("testKey", {_ in 78}, {_,_ in})
        XCTAssertEqual(sut.getContent(), 78)
    }
    func testCounterPresenterImplActsLikeContentPresenter() {
        let view = CounterViewSpy()
        let presenter = CounterPresenterImpl(view)
        presenter.present(content: 45)
        XCTAssertEqual(view.showCallCount, 1)
        XCTAssertEqual(view.showedValue, "45")
    }
}
