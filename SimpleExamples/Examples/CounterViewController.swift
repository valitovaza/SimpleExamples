import UIKit
import Core

class CounterViewController: UIViewController {
    
    private var eventHandler: CounterViewEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDependencies()
        eventHandler.onDidLoad()
    }
    
    override func registerDependencies() {
        DependencyContainer.register(CounterView.self, { self })
        eventHandler = DependencyContainer.resolve(CounterViewEventHandler.self)
    }
    
    override func releaseDependencies() {
        DependencyContainer.release(CounterView.self)
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
