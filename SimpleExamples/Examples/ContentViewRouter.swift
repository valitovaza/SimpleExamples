import Core

class ContentViewRouterImpl {
    private let navigator: ErrorHandlingNavigator
    private let counterVcFactory: ViewControllerFactory
    init(_ navigator: ErrorHandlingNavigator,
         _ counterVcFactory: @escaping ViewControllerFactory) {
        self.navigator = navigator
        self.counterVcFactory = counterVcFactory
    }
}
extension ContentViewRouterImpl: ContentViewRouter {
    func openCounterScreen() {
        navigator.push(viewController: counterVcFactory(), animated: true)
    }
}
