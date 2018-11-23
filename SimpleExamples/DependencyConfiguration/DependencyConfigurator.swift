import Foundation

final class DependencyConfigurator {
    private static var isTestHostingDependenciesRegistered = false
    static func register() {
        if canRegister {
            registerAllDependencies()
        }else{
            registerStubForTestsHostingApp()
        }
    }
    private static var canRegister: Bool {
        return !isUnitTesting
    }
    private static var isUnitTesting: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    private static func registerAllDependencies() {
        Dependencies.registerDependencies()
    }
    private static func registerStubForTestsHostingApp() {
        guard !isTestHostingDependenciesRegistered else { return }
        isTestHostingDependenciesRegistered = true
        Dependencies.registerHostAppStub()
    }
}
