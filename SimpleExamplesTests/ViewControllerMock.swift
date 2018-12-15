import XCTest
@testable import SimpleExamples

class ViewControllerMock: UIViewController {
    var presentCallCount = 0
    var presentedVc: UIViewController?
    var presentAnimatedFlag: Bool?
    var presentCompletion: (() -> Void)?
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentCallCount += 1
        presentedVc = viewControllerToPresent
        presentAnimatedFlag = flag
        presentCompletion = completion
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
