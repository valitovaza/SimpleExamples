import Core

enum CommonDependenciesRegistrator {
    static func registerDependencies() {
        //ErrorHandler
        DependencyContainer.register(ErrorHandler.self, {
            Dependencies.SharedStaticVariables.errorHandler
        })
        
        //NavigatorFactory
        DependencyContainer.register(NavigatorFactory.self, {
            Dependencies.createSingleWeak(NavigatorFactoryImpl.self, {
                NavigatorFactoryImpl()
            })
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
