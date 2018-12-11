import Core

enum CommonDependenciesRegistrator {
    static func registerDependencies() {
        //ErrorHandler
        DependencyContainer.register(ErrorHandler.self, {
            Dependencies.SharedStaticVariables.errorHandler
        })
    }
}
