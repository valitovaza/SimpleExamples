import Core
import UIKit

typealias ViewControllerFactory = () -> (UIViewController)

class MainRouter {
    private let screenSwitcher: ContainerScreenSwitcher
    private let navigator: ErrorHandlingNavigator
    private let loadingFactory: ViewControllerFactory
    private let contentFactory: ViewControllerFactory
    private let loginFactory: ViewControllerFactory
    init(_ screenSwitcher: ContainerScreenSwitcher,
         _ navigator: ErrorHandlingNavigator,
         _ loadingFactory: @escaping ViewControllerFactory,
         _ contentFactory: @escaping ViewControllerFactory,
         _ loginFactory: @escaping ViewControllerFactory) {
        self.screenSwitcher = screenSwitcher
        self.navigator = navigator
        self.loadingFactory = loadingFactory
        self.contentFactory = contentFactory
        self.loginFactory = loginFactory
    }
}
extension MainRouter: LoginCheckerRouter {
    func openLoadingScreen() {
        screenSwitcher.set(content: loadingFactory())
    }
    
    func openContentScreen() {
        screenSwitcher.set(content: contentFactory())
    }
    
    func openLoginScreen() {
        navigator.open(viewController: loginFactory(), animated: true)
    }
}
