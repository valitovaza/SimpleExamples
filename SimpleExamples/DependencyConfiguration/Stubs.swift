import Core

class ErrorPrinterStub: ErrorHandler {
    func handle(error: Error) {
        print(error)
    }
}

class LoginStateHolderStub: AsyncTaskPerformer {
    func performAsyncTask(_ completion: @escaping (AppStartState)->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.authorized)
            //completion(.notAuthorized)
        }
    }
}

class MainViewEventHandlerStub: MainViewEventHandler {
    func onLoad() {}
}
