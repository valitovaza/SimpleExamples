import Core

enum MainDependenciesRegistrator {
    static func registerDependencies() {
        //MainViewEventHandler
        DependencyContainer.register(MainViewEventHandler.self, {
            let mainRouter = MainRouter(DependencyContainer.resolve(MainScreenSwitcher.self),
                                        DependencyContainer.resolve(ErrorHandlingNavigator.self),
            {VCStoryboardInitializer.instantiate(.Main) as LoadingViewController},
            {VCStoryboardInitializer.instantiate(.Main) as ContentViewController},
            {VCStoryboardInitializer.instantiate(.Login) as LoginViewController})
            let presenter = LoginCheckerPresenter(mainRouter)
            return MainViewEventHandlerImpl(AsyncProcessorImpl(LoginStateHolderStub(), presenter))
        })
        
        //ErrorHandlingNavigator
        DependencyContainer.register(ErrorHandlingNavigator.self, {
            ErrorHandlingNavigatorImpl(DependencyContainer.resolve(Navigator.self),
                                       Dependencies.SharedStaticVariables.errorLogger)
        })
    }
}
