import Core

enum CounterDependenciesRegistrator {
    static func registerDependencies() {
        //Counter
        DependencyContainer.register(Counter.self, {
            CounterImpl(DependencyContainer.resolve(CounterRepository.self),
                        DependencyContainer.resolve(CounterPresenter.self))
        })
        
        //CounterRepository
        DependencyContainer.register(CounterRepository.self, {
            Dependencies.createSingleWeak(CounterRepositoryImpl.self, {
                CounterRepositoryImpl(Constants.UserDefaultKeys.counterKey.rawValue,
                                      UserDefaults.standard.integer(forKey:),
                                      UserDefaults.standard.set(_:forKey:))
            })
        })
        
        //CounterPresenter
        DependencyContainer.register(CounterPresenter.self, {
            CounterPresenterImpl(DependencyContainer.resolve(CounterView.self))
        })
        
        //ErrorHandlingCounter
        DependencyContainer.register(ErrorHandlingCounter.self, {
            ErrorHandlingCounterImpl(DependencyContainer.resolve(Counter.self),
                                     DependencyContainer.resolve(ErrorHandler.self))
        })
        
        //CounterViewEventHandler
        DependencyContainer.register(CounterViewEventHandler.self, {
            CounterViewEventHandlerImpl(DependencyContainer.resolve(ContentFetcher.self),
                                        DependencyContainer.resolve(ErrorHandlingCounter.self))
        })
        
        //ContentFetcher
        DependencyContainer.register(ContentFetcher.self, {
            ContentFetcherImpl(DependencyContainer.resolve(CounterRepository.self) as! CounterRepositoryImpl,
                               DependencyContainer.resolve(CounterPresenter.self) as! CounterPresenterImpl)
        })
    }
}
