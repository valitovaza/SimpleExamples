public protocol Counter {
    func increment()
    func decrement() throws
}
enum CounterError: Error {
    case cantDecrementZero
}
public class CounterImpl {
    private let repository: CounterRepository
    private let presenter: CounterPresenter
    public init(_ repository: CounterRepository,
                _ presenter: CounterPresenter) {
        self.repository = repository
        self.presenter = presenter
    }
}
extension CounterImpl: Counter {
    public func increment() {
        cacheAndPresent(newValue: repository.value + 1)
    }
    private func cacheAndPresent(newValue: Int) {
        repository.save(newValue)
        presenter.present(newValue)
    }
    public func decrement() throws {
        guard repository.value > 0 else { throw CounterError.cantDecrementZero }
        cacheAndPresent(newValue: repository.value - 1)
    }
}
