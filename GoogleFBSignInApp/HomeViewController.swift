//
//  HomeViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
import AWSS3

class HomeViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtThird: UITextField!
    @IBOutlet weak var txtFourth: UITextField!
    @IBOutlet weak var txtFifth: UITextField!
    var strTextFieldARCode: String!
    var i:Int = 0
    
    var dispatchGroup = DispatchGroup() //Instance of dispatch Group
    var strDirectoryLocation : String = ""
    /*
     14/06/2018
     open card button click action
    */
    @IBAction func btnOpenCard(_ sender: UIButton) {
        self.view.endEditing(true)
        ActivityLoader.StartAnimating(view: self.view)
        strTextFieldARCode = "\(txtFirst.text!)\(txtSecond.text!)\(txtThird.text!)\(txtFourth.text!)\(txtFifth.text!)"
        print(strTextFieldARCode.count)
        staticVariables.strARCode = "\(txtFirst.text!)\(txtSecond.text!)\(txtThird.text!)\(txtFourth.text!)\(txtFifth.text!)"
        if strTextFieldARCode.count == 5
        {
            print(strTextFieldARCode)
            //deleteFile(strFileName: "EasterBunny_HipHopDancing")
            //deleteFile(strFileName: "santaclaus_samba")
            //clearTheFolder()
            if Conectivity.isConnectedToInternet()
            {
                print("Yes! internet is available.")
                getData()
            }
            else
            {
                ActivityLoader.StopAnimating(view: self.view)
                DispatchQueue.main.async {
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Check your Internet Conectivity", view: UIApplication.topViewController()!)
                }
            }
        }
        else
        {
            ActivityLoader.StopAnimating(view: self.view)
            CreateAlerts.DisplayAlert(tittle: "Alert", message: "Enter the ARCode", view: self)
        }
        
    }
    /*
     14/06/2018
     function to clear the EncoAR folder
     */
    func clearTheFolder() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("EncoAR")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    /*
     14/06/2018
     function to delete the individual files from EncoAR folder
     */
    func deleteFile(strFileName:String) {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("/EncoAR/\(strFileName)")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldDesignConstriants()
        txtFirst.delegate = self
        txtSecond.delegate = self
        txtThird.delegate = self
        txtFourth.delegate = self
        txtFifth.delegate = self
        txtFirst.addTarget(self, action: #selector(txtFiieldDidChanged), for: UIControlEvents.editingChanged)
        txtSecond.addTarget(self, action: #selector(txtFiieldDidChanged), for: UIControlEvents.editingChanged)
        txtThird.addTarget(self, action: #selector(txtFiieldDidChanged), for: UIControlEvents.editingChanged)
        txtFourth.addTarget(self, action: #selector(txtFiieldDidChanged), for: UIControlEvents.editingChanged)
        txtFifth.addTarget(self, action: #selector(txtFiieldDidChanged), for: UIControlEvents.editingChanged)
    }
    func txtFieldDesignConstriants()
    {
        txtFirst.layer.borderWidth = 1
        txtFirst.layer.borderColor = UIColor.gray.cgColor
        txtFirst.layer.cornerRadius = 5
        txtFirst.layer.masksToBounds = true
        
        txtSecond.layer.borderWidth = 1
        txtSecond.layer.borderColor = UIColor.gray.cgColor
        txtSecond.layer.cornerRadius = 5
        txtSecond.layer.masksToBounds = true
        
        txtThird.layer.borderWidth = 1
        txtThird.layer.borderColor = UIColor.gray.cgColor
        txtThird.layer.cornerRadius = 5
        txtThird.layer.masksToBounds = true
        
        txtFourth.layer.borderWidth = 1
        txtFourth.layer.borderColor = UIColor.gray.cgColor
        txtFourth.layer.cornerRadius = 5
        txtFourth.layer.masksToBounds = true
        
        txtFifth.layer.borderWidth = 1
        txtFifth.layer.borderColor = UIColor.gray.cgColor
        txtFifth.layer.cornerRadius = 5
        txtFifth.layer.masksToBounds = true

        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    @objc func txtFiieldDidChanged(txtField : UITextField)
    {
        let txt = txtField.text
        if  txt?.count == 1 {
            switch txtField{
            case txtFirst:
                txtSecond.becomeFirstResponder()
            case txtSecond:
                txtThird.becomeFirstResponder()
            case txtThird:
                txtFourth.becomeFirstResponder()
            case txtFourth:
                txtFifth.becomeFirstResponder()
            case txtFifth:
                //txtFifth.becomeFirstResponder()
                txtFifth.resignFirstResponder()
            default:
                break
            }
        }
        if  txt?.count == 0
        {
            switch txtField
            {
                case txtFirst:
                    txtFirst.becomeFirstResponder()
                case txtSecond:
                    txtFirst.becomeFirstResponder()
                case txtThird:
                    txtSecond.becomeFirstResponder()
                case txtFourth:
                    txtThird.becomeFirstResponder()
                case txtFifth:
                    txtFourth.becomeFirstResponder()
                default:
                    break
            }
        }
        else{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //hides the keypad if user touches the screen other then keypad or tetBox
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Function to get the data from getCardByARCode api
    func getData() {
        let Url = String(format: "\(AppSettings.Urls.strARCodeUrl)")
        let serviceUrl = URL(string: Url)!
        let parameterDictionary = ["ARCode": "\(staticVariables.strARCode)"]
        print(parameterDictionary)
        //Calls the Post method from ApiServiceMethod class
        ApiServiceMethod.PostRequest(serviceUrl: serviceUrl, parameterDictionary: parameterDictionary) { (data,berror) in
            if !berror {
                print(data)
                let value = data as! [[String : AnyObject]]
                if value.count != 0
                {
                    for i in value
                    {
                        staticVariables.strAnimationName = i["Animation"] as! String
                        staticVariables.strStreamingUrl = URL(string: i["StreamingUrl"] as! String)
                        staticVariables.bIsVirtual = i["IsVirtual"] as! Bool
                        staticVariables.iUserID = i["UserID"] as! Int
                        staticVariables.strARCode = i["ARCode"] as! String
                        staticVariables.strMessage = i["Message"] as! String
                        staticVariables.strVoiceRecordingName = i["AudioMessageName"] as! String
                    }
                    self.searchForFile(strFileName: staticVariables.strAnimationName, strFolderName: AppSettings.bucket.strAssetBunldles)
                    self.searchForFile(strFileName: staticVariables.strVoiceRecordingName,strFolderName : AppSettings.bucket.strVoiceRecordings)
                    
                    self.downloadMp3()
                    ActivityLoader.StopAnimating(view: self.view)
                    //Go to Unity screen
                    staticVariables.strSongsPath = "file://\(self.strDirectoryLocation)/\(staticVariables.strStreamingUrl.lastPathComponent)"
                    staticVariables.strVoiceRecordingPath = "file://\(self.strDirectoryLocation)/\(staticVariables.strVoiceRecordingName)"
                    staticVariables.strAnimationPath = "file://\(self.strDirectoryLocation)/\(staticVariables.strAnimationName)"
                    self.dispatchGroup.notify(queue: .main, execute: {
                        self.performSegue(withIdentifier: "UnityScreen", sender: self)
                    })
                }
                else
                {
                    ActivityLoader.StopAnimating(view: self.view)
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Wrong ARCode", view: self)
                }
            }
            else
            {
                ActivityLoader.StopAnimating(view: self.view)
            }
            
            
        }
    }
    /*
     14/06/2018
     Search if the file to be downloaded is available or not
     if available then dont download the file else download
     */
    
    func searchForFile(strFileName: String,strFolderName: String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let pathComp = url.appendingPathComponent("EncoAR/")
        strDirectoryLocation = "\((pathComp?.path)!)"
        print("Directory location is \(strDirectoryLocation)")
        if let pathComponent = url.appendingPathComponent("EncoAR/\(strFileName)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("\(strFileName) FILE AVAILABLE AT \(filePath)")
            } else {
                print("\(strFileName) FILE NOT AVAILABLE")
                self.DownloadTheFile(strFileName: strFileName,strFolderName: strFolderName)
            }
        } else {
            print("\(strFileName) FILE PATH NOT AVAILABLE")
        }
    }
    
    //Download the required file from Amazon Server
    func DownloadTheFile(strFileName: String,strFolderName : String){
        dispatchGroup.enter()
        var strFileName = strFileName
        if strFolderName == "\(AppSettings.bucket.strVoiceRecordings)"
        {
            //strFileName = strVoiceRecording
            strFileName = staticVariables.strVoiceRecordingName
        }
        let transferManager = AWSS3TransferManager.default()
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let downloadingFileURL = documentsPath.appendingPathComponent("EncoAR/\(strFileName)")
        print(downloadingFileURL!)
        do {
            try FileManager.default.createDirectory(atPath: downloadingFileURL!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = AppSettings.bucket.strBucketName
        downloadRequest?.key = "\(strFolderName)/\(strFileName)"
        downloadRequest?.downloadingFileURL = downloadingFileURL
        
        transferManager.download(downloadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error downloading: \( downloadRequest!.key!)) Error: \(error)")
                        self.dispatchGroup.leave()
                    }
                } else {
                    print("Error downloading: \( downloadRequest!.key!)) Error: \(error)")
                    self.dispatchGroup.leave()
                }
                return nil
            }
            print("Download complete for: \(downloadRequest!.key!))")
            let downloadOutput = task.result
            print(downloadOutput!)
            self.dispatchGroup.leave()
            return nil
        })
    }
    
    //assigns the variable of UnityVuforiaViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UnityVuforiaViewController
        {
            destination.Controller = "Home"
            /*
            destination.strARCode = self.strARCode
            destination.strAnimationName = self.strAnimationName
            destination.iUserId = self.iUserId
            destination.bIsVirtual = self.bIsVirtual
            destination.strStreamingUrl = "file://\(strDirectoryLocation)/\(self.strStreamingUrl.lastPathComponent)"
            destination.strVoiceRecording = "file://\(strDirectoryLocation)/\(self.strVoiceRecording)"
            destination.strMessage = self.strMessage
            destination.strAnimationUrl = "file://\(strDirectoryLocation)/\(self.strAnimationName)"
            */
        }
    }
    //Download the mp3 file from Streaming Url
    func downloadMp3() {
        dispatchGroup.enter()
        if let audioUrl = staticVariables.strStreamingUrl {
            // then lets create your document folder url
            let documentsDirectoryURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("EncoAR/\(staticVariables.strStreamingUrl.lastPathComponent)")
            print(destinationUrl!)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: (destinationUrl?.path)!) {
                print("The file already exists at path")
                dispatchGroup.leave()
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl!)
                        print("File moved to documents folder")
                        self.dispatchGroup.leave()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        self.dispatchGroup.leave()
                    }
                }).resume()
            }
        }
        
    }
}

