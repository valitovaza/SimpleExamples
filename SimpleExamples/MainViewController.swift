import UIKit
import Core

class MainViewController: UIViewController {
    
    private var eventHandler: MainViewEventHandler!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerDependencies()
    }
    private func registerDependencies() {
        DependencyConfigurator.register()
        DependencyContainer.register(AggregatedNavigator.self, {
            let factory = DependencyContainer.resolve(AggregatedManualNavigatorFactory.self)
            return BackButtonHandlingNavigator(factory, self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDependencies()
        eventHandler.onLoad()
    }
    override func resolveDependencies() {
        eventHandler = DependencyContainer.resolve(MainViewEventHandler.self)
    }
}
