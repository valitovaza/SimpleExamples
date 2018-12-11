public protocol MainViewEventHandler {
    func onLoad()
}
public class MainViewEventHandlerImpl {
    private let loginChecker: AsyncProcessor
    public init(_ loginChecker: AsyncProcessor) {
        self.loginChecker = loginChecker
    }
}
extension MainViewEventHandlerImpl: MainViewEventHandler {
    public func onLoad() {
        loginChecker.process()
    }
}
