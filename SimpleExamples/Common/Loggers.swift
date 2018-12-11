protocol ErrorLogger {
    func log(error: Error)
}
class ErrorLoggerImpl: ErrorLogger {
    func log(error: Error) {
        print("🧨🧨🧨 Error ❗️❗️❗️\(error)")
    }
}

protocol CommonLogger {
    func log(_ value: Any)
}
class CommonLoggerImpl: CommonLogger {
    func log(_ value: Any) {
        print("ℹ️ℹ️ℹ️ \(value)")
    }
}
