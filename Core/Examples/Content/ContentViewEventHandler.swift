public protocol ContentViewEventHandler {
    func onCounterAction()
}
public protocol ContentViewRouter {
    func openCounterScreen()
}
public class ContentViewEventHandlerImpl {
    private let router: ContentViewRouter
    public init(_ router: ContentViewRouter) {
        self.router = router
    }
}
extension ContentViewEventHandlerImpl: ContentViewEventHandler {
    public func onCounterAction() {
        router.openCounterScreen()
    }
}
