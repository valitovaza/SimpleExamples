import UIKit

protocol ContentChildParent {
    func addContentChild(viewController: UIViewController)
    func removeContentChild(viewController: UIViewController)
}
extension UIViewController: ContentChildParent {
    @objc func addContentChild(viewController: UIViewController) {
        guard canAdd(viewController) else { return }
        addContentChild(viewController)
    }
    private func canAdd(_ viewController: UIViewController) -> Bool {
        return !children.contains(viewController)
    }
    private func addContentChild(_ viewController: UIViewController) {
        addChild(viewController)
        addChildView(viewController.view)
        viewController.didMove(toParent: self)
    }
    private func addChildView(_ childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    @objc func removeContentChild(viewController: UIViewController) {
        guard canRemove(viewController) else { return }
        removeContentChild(viewController)
    }
    private func canRemove(_ viewController: UIViewController) -> Bool {
        return children.contains(viewController)
    }
    private func removeContentChild(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
