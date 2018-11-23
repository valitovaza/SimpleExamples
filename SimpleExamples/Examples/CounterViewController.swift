import UIKit
import Core

class CounterViewController: UIViewController {
    
    private var eventHandler: CounterViewEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDependencies()
        eventHandler.onDidLoad()
    }
    private func resolveDependencies() {
        DependencyContainer.register(CounterView.self, { self })
        eventHandler = DependencyContainer.resolve(CounterViewEventHandler.self)
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
