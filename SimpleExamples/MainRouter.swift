import Core
import UIKit

typealias ViewControllerFactory = () -> (UIViewController)

class MainRouter {
    private var isContentAdded = false
    
    private let navigator: ErrorHandlingNavigator
    private let loadingFactory: ViewControllerFactory
    private let contentFactory: ViewControllerFactory
    private let loginFactory: ViewControllerFactory
    init(_ navigator: ErrorHandlingNavigator,
         _ loadingFactory: @escaping ViewControllerFactory,
         _ contentFactory: @escaping ViewControllerFactory,
         _ loginFactory: @escaping ViewControllerFactory) {
        self.navigator = navigator
        self.loadingFactory = loadingFactory
        self.contentFactory = contentFactory
        self.loginFactory = loginFactory
    }
}
extension MainRouter: LoginCheckerRouter {
    func openLoadingScreen() {
        removeContentScreenOptionally()
        navigator.add(contentScreen: loadingFactory())
        markContentAdded()
    }
    private func removeContentScreenOptionally() {
        if isContentAdded {
            navigator.removeLastContentScreen()
        }
    }
    private func markContentAdded() {
        isContentAdded = true
    }
    func openContentScreen() {
        removeContentScreenOptionally()
        navigator.add(contentScreen: contentFactory())
        markContentAdded()
    }
    
    func openLoginScreen() {
        navigator.open(viewController: loginFactory(), animated: true)
    }
}
