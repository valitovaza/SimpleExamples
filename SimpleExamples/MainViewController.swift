import UIKit

class MainViewController: UIViewController {
    override func awakeFromNib() {
        super.awakeFromNib()
        resolveDependencies()
    }
    private func resolveDependencies() {
        DependencyConfigurator.register()
    }
}
