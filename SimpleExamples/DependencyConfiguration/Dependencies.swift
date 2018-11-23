import Core

final class Dependencies {
    
    private static var container = DependencyContainer.self
    
    // MARK: - Weak shared single varibles
    
    private static var weakVariables = [String: WeakBox<AnyObject>]()
    private static func saveSingleWeak<T: AnyObject>(_ type: T.Type, _ value: T) {
        weakVariables = weakVariables.filter({ $0.value.unbox != nil })
        weakVariables[key(for: type)] = WeakBox(value)
    }
    private static func key<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    fileprivate static func createSingleWeak<T: AnyObject>(_ type: T.Type,
                                                           _ dependencyResolver: @escaping ()->(T)) -> T {
        if let weakBox = weakVariables[key(for: type)], let value = weakBox.unbox {
            return value as! T
        }else{
            let value = dependencyResolver()
            saveSingleWeak(type, value)
            return value
        }
    }
    
    //SharedStaticVariables
    fileprivate enum SharedStaticVariables {
        static let errorHandler = ErrorPrinter()
    }
    
    
    
    // MARK: - Registration
    
    static func registerHostAppStub() {
    }
    
    static func registerDependencies() {
        CommonDependencies.registerDependencies()
        CounterDependencies.registerDependencies()
    }
}

// MARK: - CommonDependencies

private enum CommonDependencies {
    static func registerDependencies() {
        //ErrorHandler
        DependencyContainer.register(ErrorHandler.self, {
            Dependencies.SharedStaticVariables.errorHandler
        })
    }
}

// MARK: - CounterDependencies

private enum CounterDependencies {
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
            Dependencies.createSingleWeak(CounterPresenterImpl.self, {
                CounterPresenterImpl(DependencyContainer.resolve(CounterView.self))
            })
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

// MARK: - Stubs

class ErrorPrinter: ErrorHandler {
    func handle(error: Error) {
        print(error)
    }
}
