import UIKit
import Core
import HelloDependency

class CounterViewController: UIViewController {
    
    private var eventHandler: CounterViewEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler = HelloDependency.resolve(CounterViewEventHandler.self)
        eventHandler.onDidLoad()
        IOSDependencyContainer.viewControllerReady(self)
    }
    
    deinit {
        print("CounterViewController: deinit")
    }
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func didTapIncrement(_ sender: Any) {
        eventHandler.onIncrementAction()
    }
    
    @IBAction func didTapDecrement(_ sender: Any) {
        eventHandler.onDecrementAction()
    }
}
extension CounterViewController: CounterView {
    func show(_ value: String) {
        countLabel.text = value
    }
}
