import XCTest

class CounterRepositoryTests: XCTestCase {

    private var sut: CounterRepositoryImpl!
    private var cache: UserDefaultsSpy!
    
    private let key = "countKey"
    
    override func setUp() {
        cache = UserDefaultsSpy()
        sut = CounterRepositoryImpl(key,
                                    cache.integer(forKey:),
                                    cache.set(_:forKey:))
    }

    override func tearDown() {
        cache = nil
        sut = nil
    }
    
    func testValueMustBeFromCache() {
        cache.testInt = 66
        XCTAssertEqual(sut.value, 66)
        XCTAssertEqual(cache.getIntForKeyCallCount, 1)
        XCTAssertEqual(cache.getKey, key)
    }
    
    func testSaveInvokeSet() {
        sut.save(33)
        XCTAssertEqual(cache.setIntCallCount, 1)
        XCTAssertEqual(cache.setInt, 33)
        XCTAssertEqual(cache.setIntKey, key)
    }
}
extension CounterRepositoryTests {
    class UserDefaultsSpy {
        var testInt: Int = 46
        var getKey: String?
        var getIntForKeyCallCount = 0
        func integer(forKey defaultName: String) -> Int {
            getIntForKeyCallCount += 1
            getKey = defaultName
            return testInt
        }
        
        var setIntCallCount = 0
        var setInt: Int?
        var setIntKey: String?
        func set(_ value: Int, forKey defaultName: String) {
            setIntCallCount += 1
            setInt = value
            setIntKey = defaultName
        }
    }
}
