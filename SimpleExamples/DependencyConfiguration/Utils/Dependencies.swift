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
    static func createSingleWeak<T: AnyObject>(_ type: T.Type,
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
    enum SharedStaticVariables {
        static let errorLogger = ErrorLoggerImpl()
        static let errorHandler = ErrorPrinterStub()
    }
    
    // MARK: - Registration
    
    static func registerHostAppStub() {
        DependencyContainer.register(MainViewEventHandler.self, {
            MainViewEventHandlerStub()
        })
    }
    
    static func registerDependencies() {
        MainDependenciesRegistrator.registerDependencies()
        CommonDependenciesRegistrator.registerDependencies()
        CounterDependenciesRegistrator.registerDependencies()
        ContentDependenciesRegistrator.registerDependencies()
    }
}
