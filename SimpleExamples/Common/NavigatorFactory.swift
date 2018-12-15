import UIKit

protocol NavigatorFactory {
    func create(_ viewController: UIViewController) -> Navigator
}
class NavigatorFactoryImpl: NavigatorFactory {
    func create(_ viewController: UIViewController) -> Navigator {
        return NavigatorImpl(viewController)
    }
}
