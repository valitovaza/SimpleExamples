import UIKit
import Core

protocol MainScreenSwitcher: ContainerScreenSwitcher {}
extension ContainerViewController: MainScreenSwitcher {}

class MainViewController: UIViewController {
    
    private var eventHandler: MainViewEventHandler!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerDependencies()
    }
    private func registerDependencies() {
        DependencyContainer.register(Navigator.self, {NavigatorImpl(self)})
        DependencyConfigurator.register()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveDependencies()
        eventHandler.onLoad()
    }
    private func resolveDependencies() {
        DependencyContainer.register(MainScreenSwitcher.self, {self.containerVc})
        eventHandler = DependencyContainer.resolve(MainViewEventHandler.self)
    }
    private var containerVc: MainScreenSwitcher {
        return children.filter({$0 is ContainerViewController}).first as! ContainerViewController
    }
}
