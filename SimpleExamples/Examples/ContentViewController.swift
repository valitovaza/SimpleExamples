import UIKit
import Core
import HelloDependency

class ContentViewController: UIViewController {
    private var eventHandler: ContentViewEventHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler = HelloDependency.resolve(ContentViewEventHandler.self)
    }
    @IBAction func counterAction(_ sender: Any) {
        eventHandler.onCounterAction()
    }
}
