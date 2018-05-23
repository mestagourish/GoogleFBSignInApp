import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import Google
import TwitterKit
class ViewController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate {

    
    /*To return a Base-64 encoded string instead of a hex encoded string, just replace
     
     let hexBytes = digest.map { String(format: "%02hhx", $0) }
     return hexBytes.joined()
     by
     
     return Data(bytes: digest).base64EncodedString()
     */
    
    var btnGoogleSignIn: GIDSignInButton!
    var btnFBSignIn: FBSDKLoginButton!
    
    var Loading:UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 280, width: 50, height: 50))
    var strEmailData: String!
    var strPassword: String!
    var strUserId: Int!
    
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtUserPass: UITextField!

    @IBAction func btnRegister(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Register", sender: self)
        }
        
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
    @IBAction func btnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        StartAnimating()
        if self.txtUserEmail.text == "" && self.txtUserPass.text == ""
        {
            StopAnimating()
            CreateAlert(tittle: "Alert", message: "Please enter the email and password")
            
        }
        else
        {
            let email : String = self.txtUserEmail.text!
            let Url = String(format: "http://wservicedeploy.pauej4cear.us-east-2.elasticbeanstalk.com/rest/Login/CheckLogin")
            let serviceUrl = URL(string: Url)!
            let parameterDictionary = ["Email":"\(email)"]
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
                            print(i["Email"]!)
                            print(i["Password"]!)
                            print(i["UserId"]!)
                            self.strEmailData = i["Email"] as! String
                            self.strPassword = i["Password"] as! String
                            self.strUserId = i["UserId"] as! Int
                        }
                    }catch let jsonError{
                        print(jsonError)
                        return
                    }
                    DispatchQueue.main.async {
                        var Encrypt : String!
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
                        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserPass.text = ""
        txtUserEmail.text = ""
    
        setupGoogleButton()
        setupFBButton()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        configureTwitterSignInButton()
    }
    func CreateAlert(tittle:String,message:String)
    {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {ACTION in
            alert.dismiss(animated: true, completion: nil)
        }))
        /*alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))*/
        self.present(alert, animated: true, completion: nil)
        
    }
    fileprivate func configureTwitterSignInButton() {
        let twitterSignInButton = TWTRLogInButton(logInCompletion: { session, error in
            if let unwrappedsession = session{
                let client = TWTRAPIClient()
                client.loadUser(withID: (unwrappedsession.userID), completion: { (user, err) in
                    guard let token = session?.authToken else {return}
                    guard let secret = session?.authTokenSecret else {return}
                    let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        if error == nil {
                            print("Twitter authentication succeed")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "Home", sender: self)
                            }
                        } else {
                            print("Twitter authentication failed")
                            
                        }
                    })
                    
                })
            }
            else
            {
                print("Error in SignIn \(error!)")
            }
        })
        //twitterSignInButton.frame = CGRect(x: 100, y: 460, width: 150, height: 50)
        twitterSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(twitterSignInButton)
        twitterSignInButton.translatesAutoresizingMaskIntoConstraints = false
        twitterSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //twitterSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        twitterSignInButton.topAnchor.constraint(equalTo: btnFBSignIn.bottomAnchor, constant: 8).isActive = true
        twitterSignInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        twitterSignInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    func setupFBButton()
    {
        btnFBSignIn = FBSDKLoginButton()
        
        //FBSignInButton.frame = CGRect(x: 100, y: 400, width: 150, height: 50)
        btnFBSignIn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(btnFBSignIn)
        btnFBSignIn.translatesAutoresizingMaskIntoConstraints = false
        btnFBSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //FBSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnFBSignIn.topAnchor.constraint(equalTo: btnGoogleSignIn.bottomAnchor, constant: 8).isActive = true
        btnFBSignIn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnFBSignIn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        btnFBSignIn.delegate = self
        btnFBSignIn.readPermissions = ["email","public_profile"]
    }
    //Custom FB Login Function
    @objc func handleCustomFBLogin()
    {
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
            if err != nil
            {
                print("Custom Fb Login Error\(err!)")
                return
            }
            self.showEmail ()
            
        }
    }
    //FACEBOOK LOGIN PROCESS
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //StartAnimating()
        if error != nil
        {
            print("Error \(error!)")
            return
        }
        print("Successfully logged in with facebook")
        self.showEmail()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Loged out of Facebook")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Logged out of Firebase")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    func showEmail ()
    {
        //GRAPH REQUEST WITH PARAMETER DICTIONARY WITH KEY FIELD
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start { (connection, result, error) in
            if error != nil
            {
                print("Failed to start the graph request\(error!)")
                return
            }
            guard let data = result as? [String:Any] else {return}
            _ = data["id"]
            //let username = data["name"]
            //let email = data["email"]
            //print("\(email!)")
            //self.UserEmail.text = "\(email!)"
            //self.UserPass.text = "\(username!)"
            //Firebase Authentication
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    // ...
                    print("Faild to Log into Firebase Facebook signin\(error!)")
                    return
                }
                print("Success in loging into firebase facebook\(user!))")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Home", sender: self)
                
            }
        }
    }
    func setupGoogleButton() {
        btnGoogleSignIn = GIDSignInButton()
        view.addSubview(btnGoogleSignIn)
        btnGoogleSignIn.translatesAutoresizingMaskIntoConstraints = false
        //googleButton.frame = CGRect(x: 100, y: 340, width: 200, height: 50)
        btnGoogleSignIn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnGoogleSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnGoogleSignIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 15).isActive = true
        btnGoogleSignIn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnGoogleSignIn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    @objc func handleCustomGoogleLogin()
    {
        GIDSignIn.sharedInstance().signIn()
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("In SignIn Google Deligate")
        if error != nil
        {
            print(error!)
            return
        }
        print("Success")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                print("Failed to create firebase ")
                return
            }
            //guard let id = user as? [String:Any] else {return}
            print("Succes to log in firebase google\(String(describing: user?.uid))")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Home", sender: self)
                
            }
            
        }
        //self.UserEmail.text = "\(user.profile.email!)"
        //self.UserPass.text = "\(user.profile.name!)"
        /*if GIDSignIn.sharedInstance().hasAuthInKeychain()
        {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Home", sender: self)
                
            }
            
        }*/
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeViewController
        {
            //destination.strname = self.strEmployeeId
        }
    }
}

