import UIKit
import Core

class ContentViewController: UIViewController {
    private var eventHandler: ContentViewEventHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDependencies()
    }
    override func resolveDependencies() {
        eventHandler = DependencyContainer.resolve(ContentViewEventHandler.self)
    }
    @IBAction func counterAction(_ sender: Any) {
        eventHandler.onCounterAction()
    }
}
