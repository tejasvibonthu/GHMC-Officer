//
//  AppDelegate.swift
//  GHMC_Officer
//
//  Created by IOSuser3 on 04/09/19.
//  Copyright © 2019 IOSuser3. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps
import IQKeyboardManagerSwift
import SideMenuSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var update = "1"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        UserDefaults.standard.set("bg", forKey:"bgImagview")
        UserDefaults.standard.synchronize()
        GMSPlacesClient.provideAPIKey("AIzaSyApZla0iJ16BznqlpmTXSuG7z3ZDSZDpXw")
        GMSServices.provideAPIKey("AIzaSyCYtfc51p8vQINhr9OzyVgPlojNUSmkt94")
         FirebaseApp.configure()
         InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                fcm_Key = result.token
            }
        }
        setupSidememu()
    
        return true
    }
    func setupSidememu()
    {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width * 0.7
     //   SideMenuController.preferences.basic.defaultCacheKey = "home"
        SideMenuController.preferences.basic.enablePanGesture = true
    }

    func openDashboard() -> Void {
        if let swController = storyboards.HomeStoryBoard.instance.instantiateInitialViewController(){
            self.window?.rootViewController = swController
            self.window?.makeKeyAndVisible()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

