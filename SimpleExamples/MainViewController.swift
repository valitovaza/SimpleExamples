import UIKit
import Core

class MainViewController: UIViewController {
    
    private var eventHandler: MainViewEventHandler!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createInitialDependencies()
    }
    private func createInitialDependencies() {
        DependencyConfigurator.register()
        DependencyContainer.register(AggregatedNavigator.self, {
            let factory = DependencyContainer.resolve(AggregatedManualNavigatorFactory.self)
            return BackButtonHandlingNavigator(factory, self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDependencies()
        eventHandler.onLoad()
    }
    override func registerDependencies() {
        eventHandler = DependencyContainer.resolve(MainViewEventHandler.self)
    }
}
