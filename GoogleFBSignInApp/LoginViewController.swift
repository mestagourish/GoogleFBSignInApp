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
    @IBOutlet weak var lblMobileNumber: UITextField!
    var strUserId : Int!
    var strPhoneNumber: String = "+91"
    var Loading:UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))
    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lblMobileNumber.resignFirstResponder()
        StartAnimating()
        Login()
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
        //StartAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func Login(){
        if self.lblMobileNumber.text == ""
        {
            StopAnimating()
            CreateAlert(tittle: "Alert", message: "Please enter the Phone Number")
            
        }
        else
        {
            let mobileNumber : String = self.lblMobileNumber.text!
            let Url = String(format: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Login/LoginRegister")
            let serviceUrl = URL(string: Url)!
            let parameterDictionary = ["Phone":"\(mobileNumber)"]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:.prettyPrinted)
            request.httpBody = httpBody
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if data != nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        print(json)
                        for i in json as! [[String: AnyObject]]
                        {
                            //print(i["Email"]!)
                            //print(i["Password"]!)
                            print(i["UserId"]!)
                            //self.strEmailData = i["Email"] as! String
                            //self.strPassword = i["Password"] as! String
                            self.strUserId = i["UserId"] as! Int
                            
                        }
                    }catch let jsonError{
                        print(jsonError)
                        return
                    }
                    DispatchQueue.main.async {
                        self.sendOtp()
                        /*var Encrypt : String!
                        Encrypt = Sha1Controller.SHA1.hexString(from: "\(self.txtUserPass.text!)" )
                        print(Encrypt)
                        if self.strEmailData == self.txtUserEmail.text && self.strPassword == Encrypt
                        {
                            self.StopAnimating()
                            print("You Loged In")
                            self.txtUserEmail.text = ""
                            self.txtUserPass.text = ""
                            self.performSegue(withIdentifier: "Home", sender: self)
                            
                        }
                        else
                        {
                            self.StopAnimating()
                            print("Wrong Email or Password")
                            self.CreateAlert(tittle: "Alert", message: "Wrong Credential")
                        }*/
                    }
                }
                else{
                    self.StopAnimating()
                    self.CreateAlert(tittle: "Alert", message: "No Internet")
                    return
                }
 
            }).resume()
        }
    }
    func sendOtp() {
        strPhoneNumber.append(self.lblMobileNumber.text!)
        PhoneAuthProvider.provider().verifyPhoneNumber(self.strPhoneNumber) { (verificationID, error) in
            if ((error) != nil) {
                // Verification code not sent.
                print(error!)
            } else {
                // Successful. User gets verification code
                // Save verificationID in UserDefaults
                UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
                UserDefaults.standard.synchronize()
                //And show the Screen to enter the Code.
                self.StopAnimating()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoToOTPVerification", sender: self)
                }
                
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OTPConfirmationViewController
        {
            //destination.strEmail = txtEmail.text
            //destination.strPassword = txtPassword.text
            //destination.strPhoneNo = txtPhoneNumber.text
            destination.strUserId = self.strUserId
        }
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


