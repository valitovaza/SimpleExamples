import HelloDependency
import Core

enum DependencyConfigurator {
    static func configure(_ rootViewController: UIViewController) {
        IOSDependencyContainer.addHostAppsRegisterationBlock {
            HelloDependency.register(MainViewEventHandler.self, {MainViewEventHandlerStub()})
        }
        
        //Commom dependencies
        IOSDependencyContainer.addRegisterationBlock {
            HelloDependency.register(ErrorHandler.self, {
                SharedStaticVariables.errorHandler
            })
            HelloDependency.Single.AndWeakly.register(NavigatorFactoryImpl.self, {
                NavigatorFactoryImpl()
            })
            HelloDependency.register(AggregatedManualNavigatorFactory.self, {
                ContentScreenNavigatorFactoryImpl(HelloDependency.resolve(NavigatorFactoryImpl.self))
            })
            HelloDependency.Single.AndWeakly.register(ErrorHandlingNavigator.self, {
                ErrorHandlingNavigatorImpl(HelloDependency.resolve(AggregatedNavigator.self),
                                           SharedStaticVariables.errorLogger)
            })
        }
        
        //Main dependencies
        IOSDependencyContainer.addRegisterationBlock {
            HelloDependency.register(AggregatedNavigator.self, {
                let factory = HelloDependency.resolve(AggregatedManualNavigatorFactory.self)
                return BackButtonHandlingNavigator(factory, rootViewController)
            })
            HelloDependency.register(MainViewEventHandler.self, {
                let mainRouter = MainRouter(HelloDependency.resolve(ErrorHandlingNavigator.self),
                                            {VCStoryboardInitializer.instantiate(.Main) as LoadingViewController},
                                            {VCStoryboardInitializer.instantiateWithNavigation(.Main, controller: ContentViewController.self)},
                                            {VCStoryboardInitializer.instantiate(.Login) as LoginViewController})
                let presenter = LoginCheckerPresenter(mainRouter)
                return MainViewEventHandlerImpl(AsyncProcessorImpl(LoginStateHolderStub(), presenter))
            })
        }
        
        //Counter dependencies
        IOSDependencyContainer.addRegisterationBlock {
            let proxy = IOSDependencyContainer.createProxy(for: CounterViewController.self)
            HelloDependency.register(CounterView.self, {proxy})
            
            HelloDependency.register(Counter.self, {
                CounterImpl(HelloDependency.resolve(CounterRepositoryImpl.self),
                            HelloDependency.resolve(CounterPresenterImpl.self))
            })
            HelloDependency.Single.AndWeakly.register(CounterRepositoryImpl.self, {
                CounterRepositoryImpl(Constants.UserDefaultKeys.counterKey.rawValue,
                                      UserDefaults.standard.integer(forKey:),
                                      UserDefaults.standard.set(_:forKey:))
            })
            HelloDependency.register(CounterPresenterImpl.self, {
                CounterPresenterImpl(HelloDependency.resolve(CounterView.self))
            })
            HelloDependency.register(ErrorHandlingCounter.self, {
                ErrorHandlingCounterImpl(HelloDependency.resolve(Counter.self),
                                         HelloDependency.resolve(ErrorHandler.self))
            })
            HelloDependency.register(CounterViewEventHandler.self, {
                CounterViewEventHandlerImpl(HelloDependency.resolve(ContentFetcher.self),
                                            HelloDependency.resolve(ErrorHandlingCounter.self))
            })
            HelloDependency.register(ContentFetcher.self, {
                ContentFetcherImpl(HelloDependency.resolve(CounterRepositoryImpl.self),
                                   HelloDependency.resolve(CounterPresenterImpl.self))
            })
        }
        
        //Content dependencies
        IOSDependencyContainer.addRegisterationBlock {
            HelloDependency.register(ContentViewEventHandler.self, {
                let router = ContentViewRouterImpl(HelloDependency.resolve(ErrorHandlingNavigator.self),
                                                   {VCStoryboardInitializer.instantiate(.Main) as CounterViewController })
                return ContentViewEventHandlerImpl(router)
            })
        }
        
        IOSDependencyContainer.register()
    }
}
fileprivate enum SharedStaticVariables {
    static let errorLogger = ErrorLoggerImpl()
    static let errorHandler = ErrorPrinterStub()
}
fileprivate enum Constants {
    enum UserDefaultKeys: String {
        case counterKey = "com.simple.examples.counter_key"
    }
}

class ErrorPrinterStub: ErrorHandler {
    func handle(error: Error) {
        print(error)
    }
}

class LoginStateHolderStub: AsyncTaskPerformer {
    func performAsyncTask(_ completion: @escaping (AppStartState)->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.authorized)
            //completion(.notAuthorized)
        }
    }
}

class MainViewEventHandlerStub: MainViewEventHandler {
    func onLoad() {}
}

extension ViewControllerProxy: CounterView {
    public func show(_ value: String) {
        executeOrPostpone { self.counterView?.show(value) }
    }
    private var counterView: CounterView? {
        return viewController as? CounterView
    }
}
