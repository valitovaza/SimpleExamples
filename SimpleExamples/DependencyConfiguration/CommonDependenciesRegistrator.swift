import Core

enum CommonDependenciesRegistrator {
    static func registerDependencies() {
        //ErrorHandler
        DependencyContainer.register(ErrorHandler.self, {
            Dependencies.SharedStaticVariables.errorHandler
        })
        
        //NavigatorFactory
        DependencyContainer.register(NavigatorFactoryImpl.self, {
            Dependencies.createSingleWeak(NavigatorFactoryImpl.self, {
                NavigatorFactoryImpl()
            })
        })
        
        //AggregatedManualNavigatorFactory
        DependencyContainer.register(AggregatedManualNavigatorFactory.self, {
            ContentScreenNavigatorFactoryImpl(DependencyContainer.resolve(NavigatorFactoryImpl.self))
        })
        
        //ErrorHandlingNavigator
        DependencyContainer.register(ErrorHandlingNavigator.self, {
            Dependencies.createSingleWeak(ErrorHandlingNavigatorImpl.self, {
                ErrorHandlingNavigatorImpl(DependencyContainer.resolve(AggregatedNavigator.self),
                                           Dependencies.SharedStaticVariables.errorLogger)
            })
        })
    }
}
