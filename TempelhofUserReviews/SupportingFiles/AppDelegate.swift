

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let injector = Injector(with: CommandLine.arguments, reviewMapper: ReviewMapper())
        let reviewsViewController = ReviewsViewController(withViewModel: injector.reviewsViewModel(), newReviewViewModel: injector.newReviewViewModel())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: reviewsViewController)
        window?.makeKeyAndVisible()

        return true
    }
}
