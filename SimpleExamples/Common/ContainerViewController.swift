import UIKit

protocol ContainerScreenSwitcher {
    func set(content viewController: UIViewController)
}
class ContainerViewController: UIViewController {
    private weak var currentContent: UIViewController?
}
extension ContainerViewController: ContainerScreenSwitcher {
    func set(content viewController: UIViewController) {
        guard canAdd(content: viewController) else { return }
        removeCurrentViewControllerOptionally()
        addChildContent(viewController)
    }
    private func canAdd(content: UIViewController) -> Bool {
        return currentContent != content
    }
    private func removeCurrentViewControllerOptionally() {
        if let currentContent = currentContent {
            currentContent.willMove(toParent: nil)
            currentContent.view.removeFromSuperview()
            currentContent.removeFromParent()
        }
    }
    private func addChildContent(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
        currentContent = viewController
    }
}
