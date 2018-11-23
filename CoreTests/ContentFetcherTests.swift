import XCTest

class ContentFetcherTests: XCTestCase {
    
    private var sut: ContentFetcherImpl<ContentHolderSpy, ContentPresenterSpy>!
    private var contentHolder: ContentHolderSpy!
    private var presenter: ContentPresenterSpy!
    
    override func setUp() {
        contentHolder = ContentHolderSpy()
        presenter = ContentPresenterSpy()
        sut = ContentFetcherImpl(contentHolder, presenter)
    }
    
    override func tearDown() {
        contentHolder = nil
        presenter = nil
        sut = nil
    }
    
    func testDidStartInvokesPresentContent() {
        sut.fetchContent()
        XCTAssertEqual(presenter.presentContentCallCount, 1)
    }
    
    func testDidStartPresentsContentFromContentHolder() {
        sut.fetchContent()
        XCTAssertEqual(presenter.presentedContent, contentHolder.testContent)
        XCTAssertEqual(contentHolder.getContentCallCount, 1)
    }
}
extension ContentFetcherTests {
    class ContentHolderSpy: ContentHolder {
        var testContent = 45
        
        var getContentCallCount = 0
        func getContent() -> Int {
            getContentCallCount += 1
            return testContent
        }
    }
    class ContentPresenterSpy: ContentPresenter {
        var presentContentCallCount = 0
        var presentedContent: Int?
        func present(content: Int) {
            presentedContent = content
            presentContentCallCount += 1
        }
    }
}
