import Core

enum MainDependenciesRegistrator {
    static func registerDependencies() {
        //MainViewEventHandler
        DependencyContainer.register(MainViewEventHandler.self, {
            let mainRouter = MainRouter(DependencyContainer.resolve(ErrorHandlingNavigator.self),
            {VCStoryboardInitializer.instantiate(.Main) as LoadingViewController},
            {VCStoryboardInitializer.instantiateWithNavigation(.Main,
                                                               controller: ContentViewController.self)},
            {VCStoryboardInitializer.instantiate(.Login) as LoginViewController})
            let presenter = LoginCheckerPresenter(mainRouter)
            return MainViewEventHandlerImpl(AsyncProcessorImpl(LoginStateHolderStub(), presenter))
        })
    }
}
