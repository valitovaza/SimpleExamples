import UIKit

protocol ViewControllerDependencyManager {
    func registerDependencies()
    func releaseDependencies()
}
extension UIViewController: ViewControllerDependencyManager {
    @objc func registerDependencies() {}
    @objc func releaseDependencies() {}
}
