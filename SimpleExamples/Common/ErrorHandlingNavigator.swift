import UIKit

typealias AggregatedNavigator = Navigator & ContentScreenNavigator

protocol ErrorHandlingNavigator {
    func open(viewController: UIViewController, animated: Bool)
    func push(viewController: UIViewController, animated: Bool)
    func back(animated: Bool)
    func add(contentScreen viewController: UIViewController)
    func removeLastContentScreen()
}
class ErrorHandlingNavigatorImpl {
    private let navigator: AggregatedNavigator
    private let logger: ErrorLogger
    init(_ navigator: AggregatedNavigator,
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
    func add(contentScreen viewController: UIViewController) {
        do {
            try navigator.add(contentScreen: viewController)
        } catch {
            logger.log(error: error)
        }
    }
    func removeLastContentScreen() {
        do {
            try navigator.removeLastContentScreen()
        } catch {
            logger.log(error: error)
        }
    }
}
