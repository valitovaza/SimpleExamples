import UIKit

protocol ErrorHandlingNavigator {
    func open(viewController: UIViewController, animated: Bool)
    func push(viewController: UIViewController, animated: Bool)
    func back(animated: Bool)
}
class ErrorHandlingNavigatorImpl {
    private let navigator: Navigator
    private let logger: ErrorLogger
    init(_ navigator: Navigator,
         _ logger: ErrorLogger) {
        self.navigator = navigator
        self.logger = logger
    }
}
extension ErrorHandlingNavigatorImpl: ErrorHandlingNavigator {
    func open(viewController: UIViewController, animated: Bool) {
        do {
            try navigator.open(viewController: viewController, animated: animated)
        } catch {
            logger.log(error: error)
        }
    }
    func push(viewController: UIViewController, animated: Bool) {
        do {
            try navigator.push(viewController: viewController, animated: animated)
        } catch {
            logger.log(error: error)
            open(viewController: viewController, animated: animated)
        }
    }
    func back(animated: Bool) {
        do {
            try navigator.back(animated: animated)
        } catch {
            logger.log(error: error)
        }
    }
}
