public protocol CounterViewEventHandler {
    func onDidLoad()
    func onIncrementAction()
    func onDecrementAction()
}
public class CounterViewEventHandlerImpl {
    private let contentFetcher: ContentFetcher
    private let counter: ErrorHandlingCounter
    public init(_ contentFetcher: ContentFetcher,
                _ counter: ErrorHandlingCounter) {
        self.contentFetcher = contentFetcher
        self.counter = counter
    }
}
extension CounterViewEventHandlerImpl: CounterViewEventHandler {
    public func onDidLoad() {
        contentFetcher.fetchContent()
    }
    
    public func onIncrementAction() {
        counter.increment()
    }
    
    public func onDecrementAction() {
        counter.decrement()
    }
}
