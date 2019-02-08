import Core

class CounterViewSpy: CounterView {
    var showCallCount = 0
    var showedValue: String?
    func show(_ value: String) {
        showedValue = value
        showCallCount += 1
    }
}
