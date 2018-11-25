import XCTest

class ErrorHandlingCounterTests: XCTestCase {

    private var sut: ErrorHandlingCounterImpl!
    private var counter: CounterSpy!
    private var errorHandler: ErrorHandlerSpy!
    
    override func setUp() {
        counter = CounterSpy()
        errorHandler = ErrorHandlerSpy()
        sut = ErrorHandlingCounterImpl(counter, errorHandler)
    }

    override func tearDown() {
        counter = nil
        errorHandler = nil
        sut = nil
    }
    
    func testIncrementInvokesCountersIncrement() {
        sut.increment()
        XCTAssertEqual(counter.incrementCallCount, 1)
        XCTAssertEqual(counter.decrementCallCount, 0)
    }
    
    func testDecrementInvokesCountersDecrement() {
        counter.needToThrowOnDecrement = false
        sut.decrement()
        XCTAssertEqual(counter.decrementCallCount, 1)
        XCTAssertEqual(counter.incrementCallCount, 0)
        XCTAssertEqual(errorHandler.handleCallCount, 0)
    }
    
    func testDecrementErrorMustBeHandled() {
        counter.needToThrowOnDecrement = true
        sut.decrement()
        XCTAssertEqual(errorHandler.handleCallCount, 1)
        XCTAssertEqual(errorHandler.handledError as? CounterError,
                       CounterError.cantDecrementZero)
    }
}
extension ErrorHandlingCounterTests {
    class CounterSpy: Counter {
        var incrementCallCount = 0
        func increment() {
            incrementCallCount += 1
        }
        
        var needToThrowOnDecrement = false
        var decrementCallCount = 0
        func decrement() throws {
            decrementCallCount += 1
            if needToThrowOnDecrement {
                throw CounterError.cantDecrementZero
            }
        }
    }
    class ErrorHandlerSpy: ErrorHandler {
        var handleCallCount = 0
        var handledError: Error?
        func handle(error: Error) {
            handledError = error
            handleCallCount += 1
        }
    }
}
