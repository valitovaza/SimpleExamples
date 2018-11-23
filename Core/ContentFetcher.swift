public protocol ContentFetcher {
    func fetchContent()
}
public protocol ContentHolder {
    associatedtype Content
    func getContent() -> Content
}
public protocol ContentPresenter {
    associatedtype Content
    func present(content: Content)
}
public class ContentFetcherImpl<CH: ContentHolder, CP: ContentPresenter> where CH.Content == CP.Content {
    private let contentHolder: CH
    private let presener: CP
    public init(_ contentHolder: CH, _ presener: CP) {
        self.contentHolder = contentHolder
        self.presener = presener
    }
}
extension ContentFetcherImpl: ContentFetcher {
    public func fetchContent() {
        presener.present(content: contentHolder.getContent())
    }
}
