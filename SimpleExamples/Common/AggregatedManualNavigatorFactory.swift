import UIKit

protocol AggregatedManualNavigatorFactory {
    func create(_ vc: UIViewController) -> AggregatedManualNavigator
}
class ContentScreenNavigatorFactoryImpl: AggregatedManualNavigatorFactory {
    
    private let innerFactory: ManualBackNavigatorFactory
    init(_ innerFactory: ManualBackNavigatorFactory) {
        self.innerFactory = innerFactory
    }
    func create(_ vc: UIViewController) -> AggregatedManualNavigator {
        let contentScreenNavigator = ContentScreenNavigatorImpl(vc, innerFactory)
        return CocoaNavigator(contentScreenNavigator)
    }
}
