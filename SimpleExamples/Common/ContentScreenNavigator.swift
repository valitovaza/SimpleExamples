import UIKit

protocol ContentScreenNavigator {
    func add(contentScreen viewController: UIViewController) throws
    func removeLastContentScreen() throws
}
class ContentScreenNavigatorImpl {
    private var presentedViewControllers: [[UIViewController]] = []
    private var navigators: [Navigator] = []
    private let navigatorFactory: NavigatorFactory
    init(_ initialVc: UIViewController,
         _ navigatorFactory: NavigatorFactory) {
        self.presentedViewControllers.append([initialVc])
        self.navigators.append(navigatorFactory.create(initialVc))
        self.navigatorFactory = navigatorFactory
    }
    private var currentNavigator: Navigator {
        return navigators.last!
    }
}
extension ContentScreenNavigatorImpl: ContentScreenNavigator {
    func add(contentScreen viewController: UIViewController) throws {
        try passIfCanAdd(viewController)
        topViewController.addContentChild(viewController: viewController)
        updateState(using: viewController)
    }
    private func passIfCanAdd(_ viewController: UIViewController) throws {
        guard !allViewControllers.contains(viewController) else {
            throw NavigatorError.cantPresentAlreadyPresentedViewController
        }
    }
    private var allViewControllers: [UIViewController] {
        return presentedViewControllers.flatMap({$0})
    }
    private var topViewController: UIViewController {
        return allViewControllers.last!
    }
    private func updateState(using viewController: UIViewController) {
        navigators.append(navigatorFactory.create(viewController))
        presentedViewControllers.append([viewController])
    }
    func removeLastContentScreen() throws {
        try passIfCanRemoveLastContentScreen()
        removeLastSavedContentScreen()
        removeLastNavigatorAndViewController()
    }
    private func passIfCanRemoveLastContentScreen() throws {
        guard presentedViewControllers.count > 1 else {
            throw NavigatorError.cantNavigateBack
        }
    }
    private func removeLastSavedContentScreen() {
        let previousIndex = presentedViewControllers.count - 2
        let lastContentScreenParent = presentedViewControllers[previousIndex].last!
        let lastContentScreen = presentedViewControllers.last!.first!
        lastContentScreenParent.removeContentChild(viewController: lastContentScreen)
    }
    private func removeLastNavigatorAndViewController() {
        presentedViewControllers.removeLast()
        navigators.removeLast()
    }
}
extension ContentScreenNavigatorImpl: Navigator {
    func open(viewController: UIViewController, animated: Bool) throws {
        try currentNavigator.open(viewController: viewController, animated: animated)
        addToCurrentContent(viewController)
    }
    private func addToCurrentContent(_ viewController: UIViewController) {
        var lastArray = presentedViewControllers.last!
        lastArray.append(viewController)
        changeLastArray(lastArray)
    }
    private func changeLastArray(_ lastArray: [UIViewController]) {
        presentedViewControllers.removeLast()
        presentedViewControllers.append(lastArray)
    }
    func push(viewController: UIViewController, animated: Bool) throws {
        try currentNavigator.push(viewController: viewController, animated: animated)
        addToCurrentContent(viewController)
    }
    func back(animated: Bool) throws {
        try currentNavigator.back(animated: animated)
        removeLastViewController()
    }
    private func removeLastViewController() {
        var lastArray = presentedViewControllers.last!
        lastArray.removeLast()
        changeLastArray(lastArray)
    }
}
