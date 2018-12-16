import UIKit

protocol ManualBackHandler {
    func removeLastPresentedViewController() throws
}

typealias AggregatedManualNavigator = AggregatedNavigator & ManualBackHandler

class BackButtonHandlingNavigator: NSObject {
    private enum NavigationType {
        case pushed
        case opened
    }
    private class PresentedInfo {
        let vc: UIViewController
        let navigationType: NavigationType
        var isAlreadyPresented = false
        init(_ vc: UIViewController, _ type: NavigationType) {
            self.vc = vc
            self.navigationType = type
        }
    }
    
    private var presentedVControllers: [[PresentedInfo]] = []
    private let navigator: AggregatedManualNavigator
    private let factory: AggregatedManualNavigatorFactory
    init(_ factory: AggregatedManualNavigatorFactory,
         _ initialVc: UIViewController) {
        self.factory = factory
        self.navigator = factory.create(initialVc)
        self.presentedVControllers.append([PresentedInfo(initialVc, .opened)])
    }
}
extension BackButtonHandlingNavigator: Navigator {
    func open(viewController: UIViewController, animated: Bool) throws {
        try navigator.open(viewController: viewController, animated: animated)
        append(info: PresentedInfo(viewController, .opened))
    }
    private func append(info: PresentedInfo) {
        var lastArray = self.lastArray
        lastArray.append(info)
        changePresented(lastArray)
    }
    private var lastArray: [PresentedInfo] {
        return presentedVControllers.last!
    }
    private func changePresented(_ lastArray: [PresentedInfo]) {
        presentedVControllers.removeLast()
        presentedVControllers.append(lastArray)
    }
    
    func push(viewController: UIViewController, animated: Bool) throws {
        try navigator.push(viewController: viewController, animated: animated)
        append(info: PresentedInfo(viewController, .pushed))
    }
    
    func back(animated: Bool) throws {
        try navigator.back(animated: animated)
        try passIfCanRemoveLastInfo()
        removeLastInfo()
    }
    private func passIfCanRemoveLastInfo() throws {
        guard lastArray.count > 1 else {
            throw NavigatorError.cantNavigateBack
        }
    }
    private func removeLastInfo() {
        var lastArray = self.lastArray
        lastArray.removeLast()
        changePresented(lastArray)
    }
}
extension BackButtonHandlingNavigator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let info = lastArray.last else { return }
        if info.isAlreadyPresented {
            removeLasPresentedOptionally(info, viewController)
        }else{
            markAlreadyPresented(info)
        }
    }
    private func markAlreadyPresented(_ info: PresentedInfo) {
        info.isAlreadyPresented = true
    }
    private func removeLasPresentedOptionally(_ last: PresentedInfo,
                                              _ currentVc: UIViewController) {
        if canRemove(last, currentVc) {
            removeLastPresentedViewController()
        }
    }
    private func canRemove(_ last: PresentedInfo,
                           _ currentVc: UIViewController) -> Bool {
        guard last.navigationType == .pushed else { return false }
        guard let previousVc = previousVc() else { return false }
        return isEqualOrNavigationRoot(currentVc: currentVc, previous: previousVc)
    }
    private func previousVc() -> UIViewController? {
        let lastArray = self.lastArray
        guard lastArray.count > 1 else { return nil }
        let prevIndex = lastArray.count - 2
        return lastArray[prevIndex].vc
    }
    private func isEqualOrNavigationRoot(currentVc: UIViewController,
                                         previous: UIViewController) -> Bool {
        guard previous != currentVc else { return true }
        guard let nav = previous as? UINavigationController else {return false}
        return nav.viewControllers.first == currentVc
    }
    private func removeLastPresentedViewController() {
        removeLastInfo()
        try? navigator.removeLastPresentedViewController()
    }
}
extension BackButtonHandlingNavigator: ContentScreenNavigator {
    func add(contentScreen viewController: UIViewController) throws {
        try navigator.add(contentScreen: viewController)
        presentedVControllers.append([PresentedInfo(viewController, .opened)])
        setDelegateOptionally(viewController)
    }
    private func setDelegateOptionally(_ viewController: UIViewController) {
        if let navigationVc = viewController as? UINavigationController {
            navigationVc.delegate = self
        }
    }
    
    func removeLastContentScreen() throws {
        try navigator.removeLastContentScreen()
        presentedVControllers.removeLast()
    }
}
