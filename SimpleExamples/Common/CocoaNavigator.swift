import UIKit

class CocoaNavigator {
    private var presentedVControllers: [[UIViewController]] = [[]]
    private let innerNavigator: AggregatedManualNavigator
    init(_ innerNavigator: AggregatedManualNavigator) {
        self.innerNavigator = innerNavigator
    }
}
extension CocoaNavigator: AggregatedManualNavigator {
    func open(viewController: UIViewController, animated: Bool) throws {
        try innerNavigator.open(viewController: viewController, animated: animated)
        append(viewController: viewController)
    }
    private func append(viewController: UIViewController) {
        var lastArray = presentedVControllers.last!
        lastArray.append(viewController)
        change(lastArray: lastArray)
    }
    private func change(lastArray: [UIViewController]) {
        presentedVControllers.removeLast()
        presentedVControllers.append(lastArray)
    }
    
    func push(viewController: UIViewController, animated: Bool) throws {
        try innerNavigator.push(viewController: viewController, animated: animated)
        append(viewController: viewController)
    }
    
    func back(animated: Bool) throws {
        try innerNavigator.back(animated: animated)
        try releaseDependenciesAndRemoveLast()
    }
    private func releaseDependenciesAndRemoveLast() throws {
        if let last = presentedVControllers.last?.last {
            last.releaseDependencies()
            removeLastViewController()
        }else{
            throw NavigatorError.cantNavigateBack
        }
    }
    private func removeLastViewController() {
        var lastArray = presentedVControllers.last!
        lastArray.removeLast()
        change(lastArray: lastArray)
    }
    
    func add(contentScreen viewController: UIViewController) throws {
        try innerNavigator.add(contentScreen: viewController)
        presentedVControllers.append([viewController])
    }
    
    func removeLastContentScreen() throws {
        try innerNavigator.removeLastContentScreen()
        try removeLast()
    }
    private func removeLast() throws {
        if presentedVControllers.count < 2 {
            throw NavigatorError.cantNavigateBack
        }else{
            let last = presentedVControllers.removeLast()
            last.forEach({$0.releaseDependencies()})
        }
    }
    
    func removeLastPresentedViewController() throws {
        try innerNavigator.removeLastPresentedViewController()
        try releaseDependenciesAndRemoveLast()
    }
}
