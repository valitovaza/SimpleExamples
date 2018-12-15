import XCTest
@testable import SimpleExamples

class NavigatorMock: Navigator, ContentScreenNavigator {
    
    var nextErrors: [NavigatorError] = []
    
    var openCallCount = 0
    var opennedVc: UIViewController?
    var openAnimatedFlag: Bool?
    func open(viewController: UIViewController, animated: Bool) throws {
        try checkThrowableError()
        openCallCount += 1
        opennedVc = viewController
        openAnimatedFlag = animated
    }
    private func checkThrowableError() throws {
        if nextErrors.count > 0 {
            throw nextErrors.remove(at: 0)
        }
    }
    
    var pushCallCount = 0
    var pushedVc: UIViewController?
    var pushAnimatedFlag: Bool?
    func push(viewController: UIViewController, animated: Bool) throws {
        try checkThrowableError()
        pushCallCount += 1
        pushedVc = viewController
        pushAnimatedFlag = animated
    }
    
    var backCallCount = 0
    var backAnimatedFlag: Bool?
    func back(animated: Bool) throws {
        try checkThrowableError()
        backCallCount += 1
        backAnimatedFlag = animated
    }
    
    var addContentScreenCallCount = 0
    var addedVc: UIViewController?
    func add(contentScreen viewController: UIViewController) throws {
        try checkThrowableError()
        addContentScreenCallCount += 1
        addedVc = viewController
    }
    
    var removeLastContentScreenCallCount = 0
    func removeLastContentScreen() throws {
        try checkThrowableError()
        removeLastContentScreenCallCount += 1
    }
}
