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
    var strUserId : Int!
    var mommentAsFirstScreen : Bool = false
     var Loading:UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))
    @IBAction func btnConfirm(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lblOtpConfirmation.resignFirstResponder()
        StartAnimating()
        OtpConfirmation()
    }
    func StartAnimating(){
        //Loading.center = self.view.center
        view.addSubview(Loading)
        Loading.translatesAutoresizingMaskIntoConstraints = true
        Loading.hidesWhenStopped = true
        Loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        Loading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func OtpConfirmation() {
        let verificationID = UserDefaults.standard.value(forKey: "firebase_verification")
        print (verificationID!)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode: self.lblOtpConfirmation.text!)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                self.StopAnimating()
                self.CreateAlert(tittle: "Alert", message: "Wrong OTP")
                return
            }
            print("Result\(authResult!)")
            // User is signed in
            self.callApi()
            self.StopAnimating()
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            //self.CreateAlert(tittle: "Alert", message: "Successfully Registered")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "goToSwipeScreen", sender: self)
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SwipeViewController
        {
            //destination
            destination.momentAsFirstScreen = true
        }
    }
    func callApi() {
        let Url = String(format: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Login/OTPVerification")
        let serviceUrl = URL(string: Url)!
        let parameterDictionary = ["UserId":"\(self.strUserId!)","IsOTPVerification":"true"]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:.prettyPrinted)
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if data != nil{
                print(response!)
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
            }
            else
            {
                print(error!)
            }
        }).resume()
        
    }
    func CreateAlert(tittle:String,message:String)
    {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {ACTION in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


