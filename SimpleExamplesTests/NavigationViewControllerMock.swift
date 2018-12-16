import XCTest
@testable import SimpleExamples

class NavigationViewControllerMock: UINavigationController {
    var pushViewControllerCallCount = 0
    var pushAnimationFlag: Bool?
    var pushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController,
                                     animated: Bool) {
        pushAnimationFlag = animated
        pushedViewController = viewController
        pushViewControllerCallCount += 1
    }
    
    var popViewControllerCallCount = 0
    var popAnimationFlag: Bool?
    override func popViewController(animated: Bool) -> UIViewController? {
        popAnimationFlag = animated
        popViewControllerCallCount += 1
        return nil
    }
    
    var presentCallCount = 0
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentCallCount += 1
    }
    
    var dismissCallCount = 0
    var dismissAnimatedFlag: Bool?
    var dismissCompletion: (() -> Void)?
    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        dismissCallCount += 1
        dismissAnimatedFlag = flag
        dismissCompletion = completion
    }
}
