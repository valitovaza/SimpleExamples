public protocol CounterPresenter {
    func present(_ value: Int)
}
public protocol CounterView: class {
    func show(_ value: String)
}
public class CounterPresenterImpl {
    private weak var view: CounterView?
    public init(_ view: CounterView) {
        self.view = view
    }
}
extension CounterPresenterImpl: CounterPresenter {
    public func present(_ value: Int) {
        view?.show(String(value))
    }
}
