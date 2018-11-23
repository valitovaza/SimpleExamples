import XCTest

class CounterViewEventHandlerTests: XCTestCase {

    private var sut: CounterViewEventHandlerImpl!
    private var contentFetcher: ContentFetcherSpy!
    private var counter: ErrorHandlingCounterSpy!
    
    override func setUp() {
        super.setUp()
        contentFetcher = ContentFetcherSpy()
        counter = ErrorHandlingCounterSpy()
        sut = CounterViewEventHandlerImpl(contentFetcher, counter)
    }
    
    override func tearDown() {
        contentFetcher = nil
        counter = nil
        sut = nil
        super.tearDown()
    }
    
    func testOnDidLoadInvokesFetchContent() {
        sut.onDidLoad()
        XCTAssertEqual(contentFetcher.fetchContentCallCount, 1)
        XCTAssertEqual(counter.incrementCallCount, 0)
        XCTAssertEqual(counter.decrementCallCount, 0)
    }
    
    func testOnIncrementActionInvokesIncrement() {
        sut.onIncrementAction()
        XCTAssertEqual(counter.incrementCallCount, 1)
        XCTAssertEqual(contentFetcher.fetchContentCallCount, 0)
        XCTAssertEqual(counter.decrementCallCount, 0)
    }
    
    func testOnDecrementActionInvokesDecrement() {
        sut.onDecrementAction()
        XCTAssertEqual(counter.decrementCallCount, 1)
        XCTAssertEqual(counter.incrementCallCount, 0)
        XCTAssertEqual(contentFetcher.fetchContentCallCount, 0)
    }
}
extension CounterViewEventHandlerTests {
    class ContentFetcherSpy: ContentFetcher {
        var fetchContentCallCount = 0
        func fetchContent() {
            fetchContentCallCount += 1
        }
    }
    class ErrorHandlingCounterSpy: ErrorHandlingCounter {
        var incrementCallCount = 0
        func increment() {
            incrementCallCount += 1
        }
        
        var decrementCallCount = 0
        func decrement() {
            decrementCallCount += 1
        }
    }
}
