import UIKit

protocol ViewControllerDependencyManager {
    func resolveDependencies()
    func releaseDependencies()
}
extension UIViewController: ViewControllerDependencyManager {
    @objc func resolveDependencies() {}
    @objc func releaseDependencies() {}
}
