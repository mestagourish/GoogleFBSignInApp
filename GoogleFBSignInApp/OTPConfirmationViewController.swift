//
//  OtpConfirmationViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
class OTPConfirmationViewController: UIViewController,MessagingDelegate{
    @IBOutlet weak var lblOtpConfirmation: UITextField!
    var mommentAsFirstScreen : Bool = false
     var Loading:UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))
    /*
     12/05/2018
     //confirm OTP button click event
     */
    
    @IBAction func btnConfirm(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lblOtpConfirmation.resignFirstResponder()
        //StartAnimating()
        if Conectivity.isConnectedToInternet()
        {
            print("Yes! internet is available.")
            //StartAnimating()
            ActivityLoader.StartAnimating(view: self.view)
            OtpConfirmation()
        }
        else
        {
            DispatchQueue.main.async {
                CreateAlerts.DisplayAlert(tittle: "Alert", message: "Check your Internet Conectivity", view: UIApplication.topViewController()!)
            }
        }
        
    }
    /*
     11/05/2018
     //Starts the loader on the screen
     */
    
    func StartAnimating(){
        //Loading.center = self.view.center
        view.addSubview(Loading)
        Loading.translatesAutoresizingMaskIntoConstraints = true
        Loading.hidesWhenStopped = true
        Loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        Loading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    /*
     11/05/2018
     //Stops the loader on the screen
     */
    
    func StopAnimating() {
        DispatchQueue.main.async {
            self.Loading.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        self.lblOtpConfirmation.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     22/05/2018
     //hides the keypad if user touches the screen other then keypad or tetBox
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
     12/05/2018
     Functions checks the Otp entered by the user is valid or not
     if Valid the user is provided with the Moment and Home Swipe Screen
     else an alert is given saying the OTP entred is not Valid
     */
    /*
    */
    func OtpConfirmation() {
        let verificationID = UserDefaults.standard.value(forKey: "firebase_verification")
        print (verificationID!)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode: self.lblOtpConfirmation.text!)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                ActivityLoader.StopAnimating(view: self.view)
                //self.StopAnimating()
                //Creates a Alert on to the Screen if wrong OTP is entered
                CreateAlerts.DisplayAlert(tittle: "Alert", message: "Wrong OTP", view: self)
                return
            }
            print("Result\(authResult!)")
            // User is signed in
            self.callApi()
            ActivityLoader.StopAnimating(view: self.view)
            //self.StopAnimating()
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            //self.CreateAlert(tittle: "Alert", message: "Successfully Registered")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "goToSwipeScreen", sender: self)
            }
            
        }
        
    }
    /*
     12/05/2018
     This function sends a booleen true value to the swipe viewcontroller so that
     the user is provided with home and Moment swipe screen
     */
    /*
    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SwipeViewController
        {
            destination.momentAsFirstScreen = true
        }
    }
    /*
     12/05/2018
     Function Calls the api method to give the user all the required access
     */
    /*
     Modified
     11/06/2018
     */
    func callApi() {
        let Url = String(format: "\(AppSettings.Urls.strOTPConfirmationUrl)")
        let serviceUrl = URL(string: Url)!
        let parameterDictionary = ["UserID":"\(staticVariables.iUserID!)","IsOTPVerification":"true"]
        //let parameterDictionary = ["UserID":"\(self.iUserId!)","IsOTPVerification":"true"]
        //Calls the Post method from ApiServiceMethod class
        ApiServiceMethod.PostRequest(serviceUrl: serviceUrl, parameterDictionary: parameterDictionary) { (data,berror) in
            if !berror {
                print(data)
            }
            else
            {
                ActivityLoader.StopAnimating(view: self.view)
            }
            
        }
    }
}


