public protocol LoginCheckerRouter {
    func openLoadingScreen()
    func openContentScreen()
    func openLoginScreen()
}
public class LoginCheckerPresenter {
    private let router: LoginCheckerRouter
    public init(_ router: LoginCheckerRouter) {
        self.router = router
    }
}
public enum AppStartState {
    case notAuthorized
    case authorized
}
extension LoginCheckerPresenter: AsyncTaskWaiter {
    public func taskStarted() {
        router.openLoadingScreen()
    }
    public func taskFinished(_ content: AppStartState) {
        switch content {
        case .authorized:
            router.openContentScreen()
        case .notAuthorized:
            router.openLoginScreen()
        }
    }
}
