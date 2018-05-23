//
//  AppDelegate.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 04/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import Google
import TwitterKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       TWTRTwitter.sharedInstance().start(withConsumerKey:"I9Ex1Ga63bmyTBolCBlSrXGle", consumerSecret: "HUltzrnK1daXcj38Crdbh4Y6iRrqnCaKryOUFzW6VKGR3KO4hF")
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookAuthentication  = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication:options [UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        
        let googleAuthentication = GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options [UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                          annotation: [UIApplicationOpenURLOptionsKey.annotation])
        
        let twitterAuthentication = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        //return googleAuthentication
        return facebookAuthentication || twitterAuthentication || googleAuthentication
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth.
        let firebaseAuth = Auth.auth()
        
        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        
        //At time of production it will be set to .prod
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            print("User Info\(userInfo)")
            return
        }
    }

}

