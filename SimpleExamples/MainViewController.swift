import UIKit
import Core
import HelloDependency

class MainViewController: UIViewController {
    
    private var eventHandler: MainViewEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler = HelloDependency.resolve(MainViewEventHandler.self)
        eventHandler.onLoad()
    }
}
