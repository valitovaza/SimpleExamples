import XCTest
@testable import SimpleExamples

class ManualBackNavigatorFactorySpy: ManualBackNavigatorFactory {
    var createCallCount = 0
    var createVc: UIViewController?
    var createdNavigators: [NavigatorMock] = []
    func create(_ viewController: UIViewController) -> ManualBackNavigator {
        createCallCount += 1
        createVc = viewController
        let navigator = NavigatorMock()
        createdNavigators.append(navigator)
        return navigator
    }
    var currentNavigator: NavigatorMock {
        return createdNavigators.last!
    }
}
