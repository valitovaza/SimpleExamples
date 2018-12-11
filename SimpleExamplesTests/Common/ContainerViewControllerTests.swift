import XCTest
@testable import SimpleExamples

class ContainerViewControllerTests: XCTestCase {

    private var sut: ContainerViewController!
    
    override func setUp() {
        sut = commonSBoard.instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController
        _ = sut.view
    }
    private var commonSBoard: UIStoryboard {
        return UIStoryboard(name: "Common", bundle: nil)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testSetContentMustAddViewControllerAsAChild() {
        let childVc = ChildViewControllerMock()
        sut.set(content: childVc)
        XCTAssertEqual(childVc.willMoveToParentCallCount, 1)
        XCTAssertTrue(sut.children.contains(childVc))
        XCTAssertTrue(sut.view.subviews.contains(childVc.view))
        XCTAssertEqual(childVc.didMoveToParentCallCount, 1)
        XCTAssertFalse(childVc.view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(sut.view.constraints.count, 4)
    }
    
    func testSetSecondContentMustRemoveFirst() {
        let childVc0 = ChildViewControllerMock()
        sut.set(content: childVc0)
        let childVc1 = ChildViewControllerMock()
        sut.set(content: childVc1)
        XCTAssertNil(childVc0.willMoveParent)
        XCTAssertEqual(childVc0.willMoveToParentCallCount, 2)
        XCTAssertFalse(sut.view.subviews.contains(childVc0.view))
        XCTAssertFalse(sut.children.contains(childVc0))
    }
    
    func testSetSameContentSecondTimeMustBeIgnored() {
        let childVc = ChildViewControllerMock()
        sut.set(content: childVc)
        sut.set(content: childVc)
        XCTAssertEqual(childVc.didMoveToParentCallCount, 1)
    }
}
extension ContainerViewControllerTests {
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
    }
}
