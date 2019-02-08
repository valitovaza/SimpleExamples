import XCTest
import Core

class CounterPresenterTests: XCTestCase {

    private var sut: CounterPresenterImpl!
    private var view: CounterViewSpy!
    
    override func setUp() {
        view = CounterViewSpy()
        sut = CounterPresenterImpl(view)
    }

    override func tearDown() {
        view = nil
        sut = nil
    }
    
    func testPresentInvokesShow() {
        sut.present(4)
        XCTAssertEqual(view.showCallCount, 1)
        XCTAssertEqual(view.showedValue, "4")
    }
    
    func testViewMustBeWeak() {
        var view: CounterViewSpy? = CounterViewSpy()
        weak var weakView = view
        sut = CounterPresenterImpl(view!)
        view = nil
        XCTAssertNil(weakView)
    }
}
