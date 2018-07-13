//
//  TestPreviewCardViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/07/18.
//  Copyright © 2018 Edot. All rights reserved.
//
import Foundation
import UIKit
import AWSS3
import AWSCognito

class TestPreviewCardViewController: UIViewController {
    
    var songs : [Songs] = staticVariables.oSongs
    var Quotes : [Quotes] = staticVariables.oQuotes
    var dispatchGroup = DispatchGroup()
    var strDirectoryLocation : String = ""
    let Topline : UIBezierPath = {
       let line = UIBezierPath()
        UIColor.black.setStroke()
        line.stroke()
        return line
    }()
    
    let BottomLine : UIBezierPath = {
       let line = UIBezierPath()
        UIColor.black.setStroke()
        line.stroke()
        return line
    }()
    
    let btnBack : UIButton = {
       let btn = UIButton()
       btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named : "back-arrow"), for: .normal)
        btn.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        return btn
    }()
    
    let btnHome : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named : "home_"), for: .normal)
        btn.addTarget(self, action: #selector(btnHomeAction), for: .touchUpInside)
        return btn
    }()
    
    let btnPreview : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn.setTitle("Preview", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.4529591799, green: 0.1135742739, blue: 0.08375357836, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(btnPreviewAction), for: .touchUpInside)
        
        return btn
    }()
    
    let btnCheckOut : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("CheckOut", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let imgTittle : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named : "Peacolo")
        return img
    }()
    
    let imgARCard : UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        return img
    }()
    
    let cardView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8544243855, green: 1, blue: 0.9805173332, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.masksToBounds  = true
        return view
    }()
    let lblPreviewCard : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "PreviewCard"
        lbl.textColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        lbl.font = UIFont(name: "Arial", size: 20)
        return lbl
    }()
    let line1 : UILabel = {
      let lbl = UILabel()
        lbl.text = "----------------------------------"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont(name: "Arial", size: 17)
        lbl.textAlignment = NSTextAlignment.center
        //lbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
       // lbl.layer.borderWidth = 1
      //lbl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return lbl
    }()
    let line2 : UILabel = {
        let lbl = UILabel()
        lbl.text = "-------------------------"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont(name: "Arial", size: 17)
        //lbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        //lbl.layer.borderWidth = 1
        //lbl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return lbl
    }()
    let lblLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Virtual Message On Camera"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont(name: "Arial", size: 20)
        //lbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        //lbl.layer.borderWidth = 1
        lbl.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return lbl
    }()
    //Create UITextField for Recipient
    let txtRecipient : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.masksToBounds = true
        textField.placeholder = "Receipent Name"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    //Create UITextField for Recipient
    let txtInitials : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.masksToBounds = true
        textField.placeholder = "Initials"
        textField.textAlignment = NSTextAlignment.right
        return textField
    }()
    //Create UITextField for Recipient
    let txtViewMessage : UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Text Message"
        textField.sizeToFit()
        textField.isScrollEnabled = false
        textField.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textField.layer.masksToBounds = true
        textField.textAlignment = NSTextAlignment.center
        textField.sizeToFit()
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imgTittle)
        imgTittle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imgTittle.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imgTittle.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        imgTittle.widthAnchor.constraint(equalToConstant: 249).isActive = true
        view.addSubview(btnBack)
        btnBack.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        //btnBack.rightAnchor.constraint(equalTo: imgTittle.leftAnchor, constant: -5).isActive = true
        btnBack.widthAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        btnBack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: +24).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(btnHome)
        btnHome.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        btnHome.topAnchor.constraint(equalTo: self.view.topAnchor, constant: +24).isActive = true
        btnHome.leftAnchor.constraint(equalTo: imgTittle.rightAnchor, constant: +5).isActive = true
        btnHome.widthAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        btnHome.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(lblPreviewCard)
        lblPreviewCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lblPreviewCard.topAnchor.constraint(equalTo: imgTittle.bottomAnchor, constant: +8).isActive = true
        lblPreviewCard.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        lblPreviewCard.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        
        view.addSubview(btnCheckOut)
        btnCheckOut.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        btnCheckOut.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -5).isActive = true
        btnCheckOut.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        btnCheckOut.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //btnCheckOut.topAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: +5).isActive = true
        view.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: lblPreviewCard.bottomAnchor, constant: +5).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: +30).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        cardView.addSubview(imgARCard)
        imgARCard.topAnchor.constraint(equalTo: cardView.topAnchor, constant: +10).isActive = true
        imgARCard.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        imgARCard.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        imgARCard.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        cardView.addSubview(line1)
        //line1.topAnchor.constraint(equalTo: imgARCard.bottomAnchor, constant: +5).isActive = true
        line1.topAnchor.constraint(equalTo: imgARCard.bottomAnchor).isActive = true
        line1.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        line1.heightAnchor.constraint(lessThanOrEqualToConstant: 10).isActive = true
        line1.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        
        cardView.addSubview(lblLabel)
        lblLabel.topAnchor.constraint(equalTo: line1.bottomAnchor).isActive = true
        lblLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        lblLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 20).isActive = true
        //lblLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        cardView.addSubview(txtRecipient)
        txtRecipient.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        txtRecipient.topAnchor.constraint(equalTo: lblLabel.bottomAnchor).isActive = true
        txtRecipient.heightAnchor.constraint(equalToConstant: 40).isActive = true
        txtRecipient.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true
        cardView.addSubview(txtViewMessage)
        txtViewMessage.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        txtViewMessage.topAnchor.constraint(equalTo: txtRecipient.bottomAnchor).isActive = true
        txtViewMessage.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        txtViewMessage.widthAnchor.constraint(equalTo: txtRecipient.widthAnchor).isActive = true
        cardView.addSubview(txtInitials)
        txtInitials.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        txtInitials.topAnchor.constraint(equalTo: txtViewMessage.bottomAnchor).isActive = true
        txtInitials.heightAnchor.constraint(equalToConstant: 40).isActive = true
        txtInitials.widthAnchor.constraint(equalTo: txtRecipient.widthAnchor).isActive = true
        cardView.addSubview(line2)
        line2.topAnchor.constraint(equalTo: txtInitials.bottomAnchor).isActive = true
        line2.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        line2.heightAnchor.constraint(lessThanOrEqualToConstant: 10).isActive = true
        line2.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        cardView.addSubview(btnPreview)
        btnPreview.topAnchor.constraint(greaterThanOrEqualTo: line2.bottomAnchor, constant: +5).isActive = true
        //btnPreview.topAnchor.constraint(: line2.bottomAnchor, constant: +5).isActive = true
        btnPreview.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        btnPreview.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -5).isActive = true
        btnPreview.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btnPreview.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        

        // Do any additional setup after loading the view.
        //imgARCard.downloadedFrom(link: "\(strMomentUrl)")
        //txtViewMessage.text = strMessage
        //txtRecipient.text = strReceipentName
        //txtInitials.text = strInitials
        imgARCard.downloadedFrom(link: "\(staticVariables.strMomentUrl)")
        txtViewMessage.text = staticVariables.strMessage
        txtRecipient.text = staticVariables.strRecipentName
        txtInitials.text = staticVariables.strInitials
    }
    @objc func btnBackAction()
    {
        self.performSegue(withIdentifier: "TestBack", sender: self)
    }
    @objc func btnHomeAction()
    {
        self.performSegue(withIdentifier: "FromTestPreview", sender: self)
    }
    @objc func btnPreviewAction()
    {
        ActivityLoader.StartAnimating(view: self.view)
        let isongsID = staticVariables.oSongs[staticVariables.prevSelectedSongCell.row].SongID!
        let iQuotesID = staticVariables.oQuotes[staticVariables.prevSelectedMessageCell.row].QuoteID!
        let iAnimationID = staticVariables.prevSelectedAnimationCell.row + 1
        let parameters = [
            "ARCode":"\(staticVariables.strARCode)","ARCardID": staticVariables.iARCardId!,"UserID": staticVariables.iUserID! ,"IsVirtual": "false" ,"SongID": isongsID ,"AnimationID": iAnimationID,"QuoteID": iQuotesID ,"AudioMessageName": staticVariables.strVoiceRecordingName] as [String : Any]
        print(parameters)
        ApiServiceMethod.PostRequest(serviceUrl: URL(string :"\(AppSettings.Urls.ARBundleUrl)")!, parameterDictionary: parameters) { (data,berror) in
            if !berror {
                CreateAlerts.DisplayAlert(tittle: "Your Generated ARCode is", message: "\(staticVariables.strARCode)", view: self)
                //ActivityLoader.StopAnimating(view: self.view)
                //let dataString = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue)
                //print(dataString!)
                self.downloadMp3()
                //downlad the animation
                self.searchForFile(strFileName: AppSettings.animationImage[staticVariables.prevSelectedAnimationCell.row] ,strFolderName : AppSettings.bucket.strAssetBunldles)
                self.uploadToAWS()
                self.dispatchGroup.notify(queue: .main, execute: {
                    ActivityLoader.StopAnimating(view: self.view)
                    self.performSegue(withIdentifier: "UnityPreview", sender: self)
                })
            }
            else
            {
                ActivityLoader.StopAnimating(view: self.view)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func parameterToPass()
    {
        staticVariables.strVoiceRecordingPath = "file://\(self.strDirectoryLocation)/\(staticVariables.strVoiceRecordingName)"
        staticVariables.strAnimationPath = "file://\(strDirectoryLocation)/\(AppSettings.animationImage[staticVariables.prevSelectedAnimationCell.row])"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let destination = segue.destination as? CreateCardViewController
        {
            destination.PrevSelectedAnimationCell = PrevSelectedAnimationCell!
            destination.PrevSelectedSongCell = PrevSelectedSongCell!
            destination.PrevSelectedMessageCell = PrevSelectedMessageCell!
            destination.strRecipientName = strReceipentName
            destination.strMomentUrl = strMomentUrl
            //destination.iARCardID = iARCardID
            print(iARCardID)
        }*/
        /*if let destination = segue.destination as? UnityVuforiaViewController
        {
            destination.PrevSelectedAnimationCell = PrevSelectedAnimationCell!
            destination.PrevSelectedSongCell = PrevSelectedSongCell!
            destination.PrevSelectedMessageCell = PrevSelectedMessageCell!
            destination.strRecipientName = txtRecipient.text!
            
            destination.strARCode = self.strARCode
            destination.iUserId = self.iUserId
            destination.bIsVirtual = self.bIsVirtual
            destination.strVoiceRecording = self.strVoiceRecording
            let SongName = URL(string : "\(self.strStreamingUrl)")
            destination.strAnimationName = self.strAnimationName
            destination.strStreamingUrl = "file://\(strDirectoryLocation)/\(SongName!.lastPathComponent)"
            destination.strVoiceRecording = "file://\(strDirectoryLocation)/\(self.strVoiceRecording)"
            destination.strMessage = self.strMessage
            destination.strMomentUrl = strMomentUrl
            destination.strAnimationUrl = "file://\(strDirectoryLocation)/\(self.strAnimationName)"
        }*/
    }
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
            strFileName = "strVoiceRecording"
        }
        let transferManager = AWSS3TransferManager.default()
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let downloadingFileURL = documentsPath.appendingPathComponent("EncoAR/\(strFileName)")
        print(downloadingFileURL!)
        staticVariables.strAnimationPath = "file://\(downloadingFileURL!)"
        do {
            try FileManager.default.createDirectory(atPath: downloadingFileURL!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            ActivityLoader.StopAnimating(view: self.view)
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
                        ActivityLoader.StopAnimating(view: self.view)
                        self.dispatchGroup.leave()
                    }
                } else {
                    print("Error downloading: \( downloadRequest!.key!)) Error: \(error)")
                    ActivityLoader.StopAnimating(view: self.view)
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
    func uploadToAWS()
    {
        dispatchGroup.enter()
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast2 , identityPoolId: "us-east-2:a3c90519-7459-4d32-b090-36a467842c43")
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let uploadTransferManager = AWSS3TransferManager.default()
        let uploadingFileURL = URL(fileURLWithPath: "\(strDirectoryLocation)/\(staticVariables.strVoiceRecordingName)")
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        //\(AppSettings.bucket.strVoiceRecordings)/
        uploadRequest?.bucket = AppSettings.bucket.strBucketName
        uploadRequest?.key = "\(AppSettings.bucket.strVoiceRecordings)/\(staticVariables.strVoiceRecordingName)"
        uploadRequest?.body = uploadingFileURL
        uploadRequest?.contentType = "audio/wav"
        uploadRequest?.acl = .publicReadWrite
        
        uploadTransferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \((uploadRequest?.key)!) Error: \(error)")
                        ActivityLoader.StopAnimating(view: self.view)
                        self.dispatchGroup.leave()
                    }
                } else {
                    print("Error uploading: \((uploadRequest?.key)!) Error: \(error)")
                    ActivityLoader.StopAnimating(view: self.view)
                   self.dispatchGroup.leave()
                }
                return nil
            }
            let uploadOutput = task.result
            print(uploadOutput)
            print("Upload complete for: \(uploadRequest!.key!)")
            self.dispatchGroup.leave()
            return nil
        })
    }
    /*
     
     */
    func downloadMp3() {
        dispatchGroup.enter()
        let streamingUrl = URL(string : staticVariables.oSongs[staticVariables.prevSelectedSongCell.row].StreamingUrl!)
        if let audioUrl = streamingUrl {
            // then lets create your document folder url
            let documentsDirectoryURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("EncoAR/\(staticVariables.strStreamingUrl.lastPathComponent)")
            print(destinationUrl!)
            staticVariables.strSongsPath = "file://\(strDirectoryLocation)/\(destinationUrl!)"
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
                        ActivityLoader.StopAnimating(view: self.view)
                        self.dispatchGroup.leave()
                    }
                }).resume()
            }
        }
        
    }
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = kCALineJoinRound
        self.cardView.layer.addSublayer(line)
    }
}
