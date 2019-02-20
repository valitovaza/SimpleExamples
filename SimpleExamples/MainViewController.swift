import UIKit
import Core
import HelloDependency

class MainViewController: UIViewController {
    
    private var isUnitTesting: Bool = {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }()
    private var isProdaction: Bool { return !isUnitTesting }
    
    private var eventHandler: MainViewEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isProdaction {
            eventHandler = HelloDependency.resolve(MainViewEventHandler.self)
            eventHandler.onLoad()
        }
    }
}
