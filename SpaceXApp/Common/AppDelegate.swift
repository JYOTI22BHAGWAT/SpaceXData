//
//  AppDelegate.swift
//  SpaceXApp
//
//  Created by JustMac on 04/12/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init(rootViewController: initialViewControlleripad)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }


}

