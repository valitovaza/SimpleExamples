import XCTest

class AsyncLoaderTests: XCTestCase {

    private var sut: AsyncLoaderImpl<ContentLoaderSpy, ContentExpectorSpy>!
    private var loader: ContentLoaderSpy!
    private var contentExpector: ContentExpectorSpy!
    
    override func setUp() {
        super.setUp()
        loader = ContentLoaderSpy()
        contentExpector = ContentExpectorSpy()
        sut = AsyncLoaderImpl(loader, contentExpector)
    }
    
    override func tearDown() {
        loader = nil
        contentExpector = nil
        sut = nil
        super.tearDown()
    }
    
    func testLoadStartsAsyncLoading() {
        sut.load()
        XCTAssertEqual(loader.loadContentCallCount, 1)
    }
    
    func testLoadInvokesLoadingStart() {
        sut.load()
        XCTAssertEqual(contentExpector.loadingStartedCallCount, 1)
        XCTAssertEqual(contentExpector.contentLoadedCallCount, 0)
    }
    
    func testLoadInvokesLoadingStartBeforeAsyncLoading() {
        loader.interceptionCallback = { [unowned self] in
            XCTAssertEqual(self.contentExpector.loadingStartedCallCount, 1)
        }
        sut.load()
    }
    
    func testLoadingCompletionInvokesContentLoaded() {
        sut.load()
        loader.loadingCompletion?(32)
        XCTAssertEqual(contentExpector.contentLoadedCallCount, 1)
        XCTAssertEqual(contentExpector.loadedContent, 32)
    }
    
    func testLoadingCompletionDoesntInvokeLoadingStarted() {
        sut.load() //1
        loader.loadingCompletion?(0)
        XCTAssertEqual(contentExpector.loadingStartedCallCount, 1)
        XCTAssertEqual(loader.loadContentCallCount, 1)
    }
}
extension AsyncLoaderTests {
    class ContentLoaderSpy: ContentLoader {
        var loadContentCallCount = 0
        var interceptionCallback: (()->())?
        var loadingCompletion: ((Int)->())?
        func loadContent(_ completion: @escaping (Int)->()) {
            interceptionCallback?()
            loadingCompletion = completion
            loadContentCallCount += 1
        }
    }
    
    class ContentExpectorSpy: ContentWaiter {
        var loadingStartedCallCount = 0
        func loadingStarted() {
            loadingStartedCallCount += 1
        }
        
        var contentLoadedCallCount = 0
        var loadedContent: Int?
        func contentLoaded(_ content: Int) {
            loadedContent = content
            contentLoadedCallCount += 1
        }
    }
}
