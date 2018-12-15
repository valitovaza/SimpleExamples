import XCTest
@testable import SimpleExamples

class ContentChildParentTests: XCTestCase {

    private var sut: UIViewController!
    
    override func setUp() {
        sut = UIViewController()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testAddContentChildMustAddViewControllerAsAChild() {
        let childVc = ChildViewControllerMock()
        sut.addContentChild(viewController: childVc)
        XCTAssertEqual(childVc.willMoveToParentCallCount, 1)
        XCTAssertTrue(sut.children.contains(childVc))
        XCTAssertTrue(sut.view.subviews.contains(childVc.view))
        XCTAssertEqual(childVc.didMoveToParentCallCount, 1)
        XCTAssertFalse(childVc.view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(sut.view.constraints.count, 4)
    }
    
    func testAddSameContentMultipleTimesMustBeIgnored() {
        let childVc = ChildViewControllerMock()
        sut.addContentChild(viewController: childVc)
        sut.addContentChild(viewController: childVc)
        XCTAssertEqual(childVc.didMoveToParentCallCount, 1)
    }
    
    func testRemoveContentChildMustBeIgnoredIfItIsNotChild() {
        let childVc = ChildViewControllerMock()
        sut.removeContentChild(viewController: childVc)
        XCTAssertEqual(childVc.willMoveToParentCallCount, 0)
        XCTAssertEqual(childVc.removeFromParentCallCount, 0)
    }
    
    func testRemoveContentChildRemovesChild() {
        let childVc = ChildViewControllerMock()
        sut.addContentChild(viewController: childVc)
        sut.removeContentChild(viewController: childVc)
        XCTAssertEqual(childVc.didMoveToParentCallCount, 2)
        XCTAssertEqual(childVc.willMoveToParentCallCount, 2)
        XCTAssertNil(childVc.willMoveParent)
        XCTAssertFalse(sut.view.subviews.contains(childVc.view))
        XCTAssertEqual(childVc.removeFromParentCallCount, 1)
    }
}
extension ContentChildParentTests {
    class ChildViewControllerMock: UIViewController {
        var willMoveToParentCallCount = 0
        var willMoveParent: UIViewController?
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            willMoveToParentCallCount += 1
            willMoveParent = parent
        }
        
        var didMoveToParentCallCount = 0
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            didMoveToParentCallCount += 1
        }
        
        var removeFromParentCallCount = 0
        override func removeFromParent() {
            super.removeFromParent()
            removeFromParentCallCount += 1
        }
    }
}
