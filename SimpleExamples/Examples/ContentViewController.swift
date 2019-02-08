import UIKit
import Core

class ContentViewController: UIViewController {
    private var eventHandler: ContentViewEventHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDependencies()
    }
    override func registerDependencies() {
        eventHandler = DependencyContainer.resolve(ContentViewEventHandler.self)
    }
    @IBAction func counterAction(_ sender: Any) {
        eventHandler.onCounterAction()
    }
}
