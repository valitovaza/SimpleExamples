final class DependencyContainer {
    
    private static var dependensies: [String: ()->(Any)] = [:]
    
    static func resolve<T>(_ type: T.Type) -> T {
        return dependensies[key(for: type)]!() as! T
    }
    private static func key<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    static func register<T>(_ type: T.Type, _ dependencyResolver: @escaping ()->(T)) {
        dependensies[key(for: type)] = dependencyResolver
    }
    static func release<T>(_ type: T.Type) {
        dependensies.removeValue(forKey: key(for: type))
    }
}
