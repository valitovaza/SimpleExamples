import XCTest
@testable import SimpleExamples

class ErrorHandlingNavigatorSpy: ErrorHandlingNavigator {
    var openCallCount = 0
    var opennedVc: UIViewController?
    var openAnimatedFlag: Bool?
    func open(viewController: UIViewController, animated: Bool) {
        openCallCount += 1
        opennedVc = viewController
        openAnimatedFlag = animated
    }
    
    var pushCallCount = 0
    var pushedVc: UIViewController?
    var pushAnimatedFlag: Bool?
    func push(viewController: UIViewController, animated: Bool) {
        pushCallCount += 1
        pushedVc = viewController
        pushAnimatedFlag = animated
    }
    
    var backCallCount = 0
    var backAnimatedFlag: Bool?
    func back(animated: Bool) {
        backCallCount += 1
        backAnimatedFlag = animated
    }
    
    var addContentScreenCallCount = 0
    var addedVc: UIViewController?
    func add(contentScreen viewController: UIViewController) {
        addContentScreenCallCount += 1
        addedVc = viewController
    }
    
    var removeLastContentScreenCallCount = 0
    var removeLastContentInterceptionCallback: (()->())?
    func removeLastContentScreen() {
        removeLastContentScreenCallCount += 1
        removeLastContentInterceptionCallback?()
    }
}
