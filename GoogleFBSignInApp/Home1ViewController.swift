//
//  HomeViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 05/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import Google
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class Home1ViewController: UIViewController,GIDSignInUIDelegate{
   
    @IBAction func btnSocialLogout(_ sender: UIBarButtonItem) {
        let GIDToken = GIDSignIn.sharedInstance().currentUser
        if GIDToken != nil{
            GIDSignIn.sharedInstance().signOut()
            print("Signed Out of Google")
        }
        else{
            print("Not Signed In Google")
        }
        
        let token = FBSDKAccessToken.current()
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            print("Logged out of Twitter")
        }
        else
        {
            print("Not Logged in Twitter")
        }
        if token != nil
        {
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            let LoginManager = FBSDKLoginManager()
            LoginManager.logOut()
        }
        else
        {
            print("facebook is not logged in")
        }
        let firebaseAuth = Auth.auth()
        do {
            print("Succesfully loged out of Firebase")
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
            print("Cookies Deleted")
        }
        // Reset view controller (this will quickly clear all the views)
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
