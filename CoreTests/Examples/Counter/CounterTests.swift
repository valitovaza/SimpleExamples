import XCTest
import Core

class CounterTests: XCTestCase {

    private var sut: CounterImpl!
    private var repository: CounterRepositorySpy!
    private var presenter: CounterPresenterSpy!
    
    override func setUp() {
        repository = CounterRepositorySpy()
        presenter = CounterPresenterSpy()
        sut = CounterImpl(repository, presenter)
    }

    override func tearDown() {
        repository = nil
        presenter = nil
        sut = nil
    }

    func testIncrementSavesIncrementedValueFromRepository() {
        repository.value = 3
        sut.increment()
        XCTAssertEqual(repository.saveCallCount, 1)
        XCTAssertEqual(repository.savedValue, 4)
    }
    
    func testIncrementPresentIncrementedValue() {
        repository.value = 5
        sut.increment()
        XCTAssertEqual(presenter.presentCallCount, 1)
        XCTAssertEqual(presenter.presentedValue, 6)
    }
    
    func testDecrementSavesDecrementedValueFromRepository() {
        repository.value = 3
        try? sut.decrement()
        XCTAssertEqual(repository.saveCallCount, 1)
        XCTAssertEqual(repository.savedValue, 2)
    }
    
    func testDecrementPresentDecrementedValue() {
        repository.value = 5
        try? sut.decrement()
        XCTAssertEqual(presenter.presentCallCount, 1)
        XCTAssertEqual(presenter.presentedValue, 4)
    }
    
    func testDecrementZeroMustThrowAnError() {
        repository.value = 0
        XCTAssertThrowsError(try sut.decrement()) { (error) in
            XCTAssertEqual(error as? CounterError, CounterError.cantDecrementZero)
        }
    }
}
extension CounterTests {
    class CounterRepositorySpy: CounterRepository {
        var value: Int = 45
        
        var saveCallCount = 0
        var savedValue: Int?
        func save(_ value: Int) {
            savedValue = value
            saveCallCount += 1
        }
    }
    class CounterPresenterSpy: CounterPresenter {
        var presentCallCount = 0
        var presentedValue: Int?
        func present(_ value: Int) {
            presentCallCount += 1
            presentedValue = value
        }
    }

}
