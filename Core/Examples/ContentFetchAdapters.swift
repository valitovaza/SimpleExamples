extension CounterRepositoryImpl: ContentHolder {
    public func getContent() -> Int {
        return value
    }
}
extension CounterPresenterImpl: ContentPresenter {
    public func present(content: Int) {
        present(content)
    }
}
