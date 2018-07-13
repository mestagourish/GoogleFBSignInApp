//
//  LoginViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Firebase
class LoginViewController: UIViewController {
    var PostCall:ApiServiceMethod?
    @IBOutlet weak var lblMobileNumber: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    var strCountryCode: String = ""
    var strPhoneNumber : String = ""
    var Loading:UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))
    /*
     10/05/2018
     //Login button Click Event
     */
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lblMobileNumber.resignFirstResponder()
        if lblMobileNumber.text?.count == 10 {
            if Conectivity.isConnectedToInternet()
            {
                print("Yes! internet is available.")
                //StartAnimating()
                ActivityLoader.StartAnimating(view: self.view)
                Login()
            }
            else
            {
                DispatchQueue.main.async {
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Check your Internet Conectivity", view: UIApplication.topViewController()!)
                }
            }
        }
        else
        {
            CreateAlerts.DisplayAlert(tittle: "Alert", message: "Wrong Phone Number", view: self)
        }
        
        
    }
    /*
     10/05/2018
     // Function Starts the circular Loader and stops the user interaction with screen
     */
    
    func StartAnimating(){
        view.addSubview(Loading)
        Loading.translatesAutoresizingMaskIntoConstraints = true
        Loading.hidesWhenStopped = true
        Loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        Loading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    /*
     10/05/2018
     // Function Stops the circular Loader and starts the user interaction with screen
     */
    
    func StopAnimating() {
        //when dealing with UI DispatchQueue.main.async needs to used
        DispatchQueue.main.async {
            self.Loading.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let CountryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(CountryCode)
            let code = countryCode.getCountryPhonceCode(CountryCode)
            print(code)
            strCountryCode = "+\(code)"
        }
        let locale = Locale.current
        //CFLocaleCopyISOCountryCodes()
        print(locale.regionCode!)
        self.lblMobileNumber.textAlignment = NSTextAlignment.center
        self.lblMobileNumber.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        //StartAnimating()
        //Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    /*
     10/05/2018
     //hides the keypad if user touches the screen other then keypad or textBox
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
     10/05/2018
     //this function calls the api login api Method
     //creates a user with new userid and the phone number entered by user
     */
    
    func Login(){
        if self.lblMobileNumber.text == ""
        {
            ActivityLoader.StopAnimating(view: self.view)
            //StopAnimating()
            //Creates a Alert and display it on the screen
            CreateAlerts.DisplayAlert(tittle: "Alert", message: "Please enter the Phone Number", view: self)
        }
        else
        {
            let strmobileNumber : String = self.lblMobileNumber.text!
            let strUrl = String(format: "\(AppSettings.Urls.strLoginUrl)")
            let serviceUrl = URL(string: strUrl)!
            let parameterDictionary = ["Phone":"\(strmobileNumber)"]
            //Calls the Post method from ApiServiceMethod class
            ApiServiceMethod.PostRequest(serviceUrl: serviceUrl, parameterDictionary: parameterDictionary, completionHandler: { (data,berror) in
                if !berror {
                    if data != nil{
                        print(data)
                        for i in data as! [[String: AnyObject]]
                        {
                            print(i["UserID"]!)
                            staticVariables.iUserID = i["UserID"] as! Int
                            UserDefaults.standard.set(staticVariables.iUserID!, forKey: "iUserID")
                        }
                        DispatchQueue.main.async {
                            self.strPhoneNumber = "\(self.strCountryCode)\(strmobileNumber)"
                            //self.strPhoneNumber = "\(strmobileNumber)"
                            self.sendOtp()
                        }
                    }
                }
                else
                {
                    ActivityLoader.StopAnimating(view: self.view)
                }
                
            })
        }
    }
    /*
     14/05/2018
     Function Sends the OTP to the phone Number specified by the user and goes to the OTP verification Page
     */
    func sendOtp() {
        PhoneAuthProvider.provider().verifyPhoneNumber(self.strPhoneNumber, uiDelegate: nil) { (verificationID, error) in
           if ((error) != nil) {
                // Verification code not sent.
                print(error!)
                ActivityLoader.StopAnimating(view: self.view)
                CreateAlerts.DisplayAlert(tittle: "Alert", message: "Wrong Phone Number", view: self)
            } else {
                // Successful. User gets verification code
                // Save verificationID in UserDefaults
                UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
                UserDefaults.standard.synchronize()
                //And show the Screen to enter the Code.
                //self.StopAnimating()
                ActivityLoader.StopAnimating(view: self.view)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoToOTPVerification", sender: self)
                }
                
            }
            
        }
    }
    /*
     14/05/2018
     Function assigns the userId in OtpConfirmationPage with the current value of  current userId
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OTPConfirmationViewController
        {
            //destination.iUserId = self.iUserId
        }
    }
    
}


