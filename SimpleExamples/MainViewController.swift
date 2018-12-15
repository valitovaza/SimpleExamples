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
            ContentScreenNavigatorImpl(self, DependencyContainer.resolve(NavigatorFactory.self))
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDependencies()
        eventHandler.onLoad()
    }
    private func resolveDependencies() {
        eventHandler = DependencyContainer.resolve(MainViewEventHandler.self)
    }
}
