import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case Main
        case Common
        case Login
        var filename: String {
            return rawValue
        }
    }
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    func instantiateViewController<T: UIViewController>() -> T {
        
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
    func instantiateViewController<T: UIViewController>(_ storyboardIdentifier: String) -> T {
        
        guard let viewController = self.instantiateViewController(withIdentifier: storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(storyboardIdentifier) ")
        }
        
        return viewController
    }
}
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
extension UIViewController: StoryboardIdentifiable { }
struct VCStoryboardInitializer {
    static func instantiate<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard) -> T {
        return UIStoryboard(storyboard: storyboard).instantiateViewController()
    }
    static func instantiate<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard, storyboardIdentifier: String) -> T {
        return UIStoryboard(storyboard: storyboard).instantiateViewController(storyboardIdentifier)
    }
    static func instantiateInitial(_ storyboard: UIStoryboard.Storyboard) -> UIViewController {
        return UIStoryboard(storyboard: storyboard).instantiateInitialViewController()!
    }
}
extension VCStoryboardInitializer {
    private static let navigationIdentifierSuffix = "Nav"
    static func instantiateWithNavigation<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard,
                                          controller: T.Type) -> UINavigationController {
        let identifier = controller.storyboardIdentifier + navigationIdentifierSuffix
        return UIStoryboard(storyboard: storyboard).instantiateViewController(identifier)
    }
}
