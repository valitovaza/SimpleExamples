import UIKit

protocol Navigator {
    func open(viewController: UIViewController, animated: Bool) throws
    func push(viewController: UIViewController, animated: Bool) throws
    func back(animated: Bool) throws
}
enum NavigatorError: Error {
    case cantNavigateBack
    case cantPush
    case cantPushAlert
    case cantPushNavigationViewController
    case cantPresentAlreadyPresentedViewController
}
class NavigatorImpl {
    private enum NavigationType {
        case pushed
        case opened
    }
    private struct PresentedInfo {
        let vc: UIViewController
        let navigationType: NavigationType
        init(_ vc: UIViewController, _ type: NavigationType) {
            self.vc = vc
            self.navigationType = type
        }
    }
    
    private var presentedInfoArray: [PresentedInfo] = []
    init(_ initialViewController: UIViewController) {
        presentedInfoArray.append(PresentedInfo(initialViewController, .opened))
    }
}
extension NavigatorImpl: Navigator {
    func open(viewController: UIViewController, animated: Bool) throws {
        guard canPresent(viewController) else {
            throw NavigatorError.cantPresentAlreadyPresentedViewController
        }
        topViewController.present(viewController, animated: animated,
                                  completion: nil)
        presentedInfoArray.append(PresentedInfo(viewController, .opened))
    }
    private func canPresent(_ viewController: UIViewController) -> Bool {
        return !isAlreadyPresented(viewController)
    }
    private func isAlreadyPresented(_ viewController: UIViewController) -> Bool {
        return presentedInfoArray.map({$0.vc}).contains(viewController)
    }
    private var topViewController: UIViewController {
        return presentedInfoArray.last!.vc
    }
    func push(viewController: UIViewController, animated: Bool) throws {
        let navVc = try navigationViewController()
        guard canPresent(viewController) else {
            throw NavigatorError.cantPresentAlreadyPresentedViewController
        }
        if viewController is UINavigationController {
            throw NavigatorError.cantPushNavigationViewController
        }
        try pushIfNotAlertController(navVc, viewController, animated)
        presentedInfoArray.append(PresentedInfo(viewController, .pushed))
    }
    private func navigationViewController() throws -> UINavigationController {
        for presentedInfo in presentedInfoArray.reversed() {
            guard presentedInfo.navigationType == .opened else { continue }
            if let navVc = presentedInfo.vc as? UINavigationController {
                return navVc
            }else{
                throw NavigatorError.cantPush
            }
        }
        throw NavigatorError.cantPush
    }
    private func pushIfNotAlertController(_ navVc: UINavigationController,
                                          _ viewController: UIViewController,
                                          _ animated: Bool) throws {
        if viewController is UIAlertController {
            throw NavigatorError.cantPushAlert
        }else{
            navVc.pushViewController(viewController, animated: animated)
        }
    }
    func back(animated: Bool) throws {
        if presentedInfoArray.count > 1 {
            let lastPresentedInfo = presentedInfoArray.removeLast()
            if lastPresentedInfo.navigationType == .pushed {
                try navigationViewController().popViewController(animated: animated)
            }else{
                lastPresentedInfo.vc.dismiss(animated: animated, completion: nil)
            }
        }else{
            throw NavigatorError.cantNavigateBack
        }
    }
}
extension NavigatorImpl: ManualBackHandler {
    func removeLastPresentedViewController() throws {
        guard presentedInfoArray.count > 1 else {
            throw NavigatorError.cantNavigateBack
        }
        presentedInfoArray.removeLast()
    }
}
