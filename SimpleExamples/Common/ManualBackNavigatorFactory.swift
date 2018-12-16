import UIKit

protocol ManualBackNavigatorFactory {
    func create(_ viewController: UIViewController) -> ManualBackNavigator
}

class NavigatorFactoryImpl: ManualBackNavigatorFactory {
    func create(_ viewController: UIViewController) -> ManualBackNavigator {
        return NavigatorImpl(viewController)
    }
}
