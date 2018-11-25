import Foundation

public protocol CounterRepository {
    var value: Int { get }
    func save(_ value: Int)
}
public class CounterRepositoryImpl {
    private let key: String
    private let valueExtractor: (String)->(Int)
    private let valueSaver: (Int, String)->()
    public init(_ countKey: String,
                _ valueExtractor: @escaping (String)->(Int),
                _ valueSaver: @escaping (Int, String)->()) {
        self.key = countKey
        self.valueExtractor = valueExtractor
        self.valueSaver = valueSaver
    }
}
extension CounterRepositoryImpl: CounterRepository {
    public var value: Int {
        return valueExtractor(key)
    }
    public func save(_ value: Int) {
        valueSaver(value, key)
    }
}
