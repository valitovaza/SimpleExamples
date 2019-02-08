import XCTest
import Core

class AsyncProcessorTests: XCTestCase {

    private var sut: AsyncProcessorImpl<AsyncTaskPerformerSpy, AsyncTaskWaiterSpy>!
    private var performer: AsyncTaskPerformerSpy!
    private var taskWaiter: AsyncTaskWaiterSpy!
    
    override func setUp() {
        super.setUp()
        performer = AsyncTaskPerformerSpy()
        taskWaiter = AsyncTaskWaiterSpy()
        sut = AsyncProcessorImpl(performer, taskWaiter)
    }
    
    override func tearDown() {
        performer = nil
        taskWaiter = nil
        sut = nil
        super.tearDown()
    }
    
    func testProcessStartsAsyncTask() {
        sut.process()
        XCTAssertEqual(performer.performAsyncTaskCallCount, 1)
    }
    
    func testProcessInvokesTaskStarted() {
        sut.process()
        XCTAssertEqual(taskWaiter.taskStartedCallCount, 1)
        XCTAssertEqual(taskWaiter.taskFinishedCallCount, 0)
    }
    
    func testProcessInvokesTaskStartedBeforePerformAsyncTask() {
        performer.interceptionCallback = { [unowned self] in
            XCTAssertEqual(self.taskWaiter.taskStartedCallCount, 1)
        }
        sut.process()
    }
    
    func testTaskCompletionInvokesTaskFinished() {
        sut.process()
        performer.taskCompletion?(32)
        XCTAssertEqual(taskWaiter.taskFinishedCallCount, 1)
        XCTAssertEqual(taskWaiter.taskContent, 32)
    }
    
    func testTaskCompletionDoesntInvokeTaskStarted() {
        sut.process() //1
        performer.taskCompletion?(0)
        XCTAssertEqual(taskWaiter.taskStartedCallCount, 1)
        XCTAssertEqual(performer.performAsyncTaskCallCount, 1)
    }
}
extension AsyncProcessorTests {
    class AsyncTaskPerformerSpy: AsyncTaskPerformer {
        var performAsyncTaskCallCount = 0
        var interceptionCallback: (()->())?
        var taskCompletion: ((Int)->())?
        func performAsyncTask(_ completion: @escaping (Int)->()) {
            interceptionCallback?()
            taskCompletion = completion
            performAsyncTaskCallCount += 1
        }
    }
    
    class AsyncTaskWaiterSpy: AsyncTaskWaiter {
        var taskStartedCallCount = 0
        func taskStarted() {
            taskStartedCallCount += 1
        }
        
        var taskFinishedCallCount = 0
        var taskContent: Int?
        func taskFinished(_ content: Int) {
            taskContent = content
            taskFinishedCallCount += 1
        }
    }
}
