//
//  RegisterViewController.swift
//  EncoAR
//
//  Created by Snehal on 14/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Firebase
extension String {
    func sha1() -> String {
        print("In encrypt")
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    var strUserID : Int!
    var strPhoneNumber: String = "+91"
    var Encrypt :  String!
    
    @IBAction func btnSendOTP(_ sender: UIButton) {
        if txtPhoneNumber.text == "" && txtEmail.text == "" && txtPhoneNumber.text == ""
        {
            self.CreateAlert(tittle: "Alert", message: "Fill in all the Fields")
        }
        else
        {
            Encrypt = Sha1Controller.SHA1.hexString(from: "\(self.txtPassword.text!)" )
            print(Encrypt)
            let Url = String(format: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Login/RegisterUser")
            let serviceUrl = URL(string: Url)!
            let parameterDictionary = ["Phone" : "\(txtPhoneNumber.text!)","Email":"\(txtEmail.text!)","Password":"\(Encrypt!)","IsOTPVerification":"false"]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:.prettyPrinted)
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if data != nil{
                    print(response!)
                    //let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print(dataString!)
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        print(json)
                        for i in json as! [[String: AnyObject]]
                        {
                            print(i["UserId"]!)
                            self.strUserID = i["UserId"] as! Int
                        }
                    }catch let jsonError{
                        print(jsonError)
                    }

                }
                else
                {
                    print(error!)
                }
            }).resume()
            
            strPhoneNumber.append(self.txtPhoneNumber.text!)
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
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "OTP", sender: self)
                    }
                    
                }
                
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OTPVerificationViewController
        {
            destination.strEmail = txtEmail.text
            destination.strPassword = txtPassword.text
            destination.strPhoneNo = txtPhoneNumber.text
            destination.strUserId = self.strUserID
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
    override func viewDidLoad() {
        super.viewDidLoad()

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
