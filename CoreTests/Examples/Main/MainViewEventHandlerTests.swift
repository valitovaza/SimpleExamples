import XCTest
import Core

class MainViewEventHandlerTests: XCTestCase {

    private var sut: MainViewEventHandlerImpl!
    private var loginChecker: AsyncProcessorSpy!
    
    override func setUp() {
        loginChecker = AsyncProcessorSpy()
        sut = MainViewEventHandlerImpl(loginChecker)
    }

    override func tearDown() {
        loginChecker = nil
        sut = nil
    }
    
    func testOnLoadInvokesProcess() {
        sut.onLoad()
        XCTAssertEqual(loginChecker.processCallCount, 1)
    }
}
extension MainViewEventHandlerTests {
    class AsyncProcessorSpy: AsyncProcessor {
        var processCallCount = 0
        func process() {
            processCallCount += 1
        }
    }
}
