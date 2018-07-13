//
//  AppDelegate.swift
//  TempelhofUserReviews
//
//  Created by Mariana Meireles on 13/07/18.
//  Copyright © 2018 Mariana Meireles. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let injector = Injector(with: CommandLine.arguments, reviewMapper: ReviewMapper())
        let reviewsViewController = ReviewsViewController(withViewModel: injector.reviewsViewModel())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = reviewsViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

