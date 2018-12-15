import Core

enum ContentDependenciesRegistrator {
    static func registerDependencies() {
        //ContentViewEventHandler
        DependencyContainer.register(ContentViewEventHandler.self, {
            let router = ContentViewRouterImpl(DependencyContainer.resolve(ErrorHandlingNavigator.self),
            {VCStoryboardInitializer.instantiate(.Main) as CounterViewController })
            return ContentViewEventHandlerImpl(router)
        })
    }
}
