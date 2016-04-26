//
//  AppDelegate.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/3/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import UIKit
import DATAStack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Model object of the application.
    var _model: Model! = nil

    override init() {
        super.init()
        let config = Config()
        _model = Model(config: config, dataStack: self.dataStack)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let navController = window?.rootViewController as? UINavigationController {
            let usersController = navController.topViewController as? UsersTableViewController

            // Set the network event indicator delegate of the model.
            _model.indicatorDelegate = self

            // Set the model for the "main"/users controller.
            usersController?.model = _model
            usersController?.dataStack = dataStack
        }
        UINavigationBar.appearance().barTintColor = UIColor(red: 75.0/255.0, green: 195.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        self.dataStack.persistWithCompletion(nil)
    }


    // MARK: - DATA stack

    lazy var dataStack: DATAStack = {
        let dataStack = DATAStack(modelName: "Sherpany")

        return dataStack
    }()
}


// MARK: - ModelNetworkIndicatorDelegate extension.

extension AppDelegate: ModelNetworkIndicatorDelegate {
    func show() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func hide() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}