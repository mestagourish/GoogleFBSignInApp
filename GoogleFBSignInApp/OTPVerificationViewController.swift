import UIKit
import Firebase
import UserNotifications

class OTPVerificationViewController: UIViewController,MessagingDelegate {
    var strEmail : String!
    var strPassword : String!
    var strPhoneNo : String!
    var strUserId : Int!
    
    @IBOutlet weak var txtOTP: UITextField!
    
    @IBAction func btnRegister(_ sender: UIButton) {
        self.view.endEditing(true)
        let verificationID = UserDefaults.standard.value(forKey: "firebase_verification")
        print (verificationID!)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode: self.txtOTP.text!)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                self.CreateAlert(tittle: "Alert", message: "Wrong OTP")
                return
            }
            print("Result\(authResult!)")
            // User is signed in
            self.callApi()
            self.CreateAlert(tittle: "Alert", message: "Successfully Registered")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popToRootViewController(animated: true)
                //self.navigationController?.popToViewController(HomeViewController(), animated: true)
                
            }
            
        }
        
    }
    func callApi() {
        let Url = String(format: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Login/RegisterUser")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        print(strPhoneNo)
        print(strPassword)
        print(strEmail)
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func CreateAlert(tittle:String,message:String)
    {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        /*let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            DispatchQueue.main.async {
                self.navigationController?.popToViewController(viewControllerYouWantToPresent!, animated: true)
            }
            //self.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)*/
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {ACTION in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
