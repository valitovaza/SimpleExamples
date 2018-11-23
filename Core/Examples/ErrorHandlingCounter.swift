public protocol ErrorHandlingCounter {
    func increment()
    func decrement()
}
public protocol ErrorHandler {
    func handle(error: Error)
}
public class ErrorHandlingCounterImpl {
    private let counter: Counter
    private let errorHandler: ErrorHandler
    public init(_ counter: Counter, _ errorHandler: ErrorHandler) {
        self.counter = counter
        self.errorHandler = errorHandler
    }
}
extension ErrorHandlingCounterImpl: ErrorHandlingCounter {
    public func increment() {
        counter.increment()
    }
    
    public func decrement() {
        do {
            try counter.decrement()
        } catch {
            errorHandler.handle(error: error)
        }
    }
}
