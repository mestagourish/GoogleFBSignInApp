//
//  AppDelegate.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 04/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import AWSMobileClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    var application: UIApplication?
    var UnityApplication : UIApplication?
    @objc var currentUnityController: UnityAppController!
    
    var isUnityRunning = false
    let vc = LaunchScreenViewController()
    //let navigationController = UINavigationController(rootViewController: vc)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //window?.rootViewController = vc
        // Override point for customization after application launch.
        let selectedBG = UIImage(named:"tabBarSelectedItem")?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        UITabBar.appearance().selectionIndicatorImage = selectedBG
        //Unity Part------
        self.application = application
        unity_init(CommandLine.argc, CommandLine.unsafeArgv)
        
        currentUnityController = UnityAppController()
        currentUnityController.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // first call to startUnity will do some init stuff, so just call it here and directly stop it again
        startUnity()
        stopUnity()
        //-------------end Unity
        
        //AWS service
        AWSMobileClient.sharedInstance().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast2 , identityPoolId: "us-east-2:a3c90519-7459-4d32-b090-36a467842c43")
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        //End Aws Service
        
        //firebase configuration
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
        //end firebase configuration
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //Unity Start
        if isUnityRunning {
            currentUnityController?.applicationWillResignActive(application)
        }
        //-------------end Unity
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //Unity Start
        if isUnityRunning {
            currentUnityController?.applicationDidEnterBackground(application)
        }
        //-------------end Unity
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Unity Start
        if isUnityRunning {
            currentUnityController?.applicationWillEnterForeground(application)
        }
        //-------------end Unity
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Unity Start
        if isUnityRunning {
            currentUnityController?.applicationDidBecomeActive(application)
        }
        
        //-------------end Unity
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //Unity Start
        if isUnityRunning {
            currentUnityController?.applicationWillTerminate(application)
        }
        //-------------end Unity
    }
    
    //Unity Start
    func startUnity() {
        if !isUnityRunning {
            isUnityRunning = true
            currentUnityController!.applicationDidBecomeActive(application!)
        }
    }
    
    func stopUnity() {
        if isUnityRunning {
            currentUnityController!.applicationWillResignActive(application!)
            isUnityRunning = false
        }
    }
    func CloseUnity()
    {
        if isUnityRunning {
            currentUnityController!.applicationWillTerminate(application!)
            isUnityRunning = false
        }
    }
    //Unity End
    
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

