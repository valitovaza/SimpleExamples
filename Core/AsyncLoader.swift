public protocol AsyncLoader {
    func load()
}
public protocol ContentLoader {
    associatedtype Content
    func loadContent(_ completion: @escaping (Content)->())
}
public protocol ContentWaiter {
    associatedtype Content
    func loadingStarted()
    func contentLoaded(_ content: Content)
}
public class AsyncLoaderImpl<Loader: ContentLoader, LoadingWaiter: ContentWaiter> where Loader.Content == LoadingWaiter.Content {
    private let loader: Loader
    private let loadingWaiter: LoadingWaiter
    init(_ loader: Loader, _ loadingWaiter: LoadingWaiter) {
        self.loader = loader
        self.loadingWaiter = loadingWaiter
    }
}
extension AsyncLoaderImpl: AsyncLoader {
    public func load() {
        loadingWaiter.loadingStarted()
        loader.loadContent { (content) in
            self.loadingWaiter.contentLoaded(content)
        }
    }
}
