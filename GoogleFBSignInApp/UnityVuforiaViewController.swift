//
//  UnityVuforiaViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 04/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit
/*
1/06/2018
 Unity Screen Implementation
 */
class UnityVuforiaViewController: UIViewController {
    var unityView: UIView?
    var Controller : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ExitUnity), name: NSNotification.Name("StopUnity"), object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startUnity()
        
        unityView = UnityGetGLView()!
        self.view!.addSubview(unityView!)
        unityView!.translatesAutoresizingMaskIntoConstraints = false
        
        // look, non-full screen unity content!
        let views = ["view": unityView]
        let w = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[view]-20-|", options: [], metrics: nil, views: views)
        let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[view]-50-|", options: [], metrics: nil, views: views)
        view.addConstraints(w + h)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            self.DisplayMessage()
        })
        
        //DisplayMessage()
 
        /*
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
         appDelegate.startUnity()
         NotificationCenter.default.addObserver(self, selector: #selector(showUnitySubView), name: NSNotification.Name("UnityReady"), object: nil)
         }*/
    }
    @IBAction func btnExitUnity(_ sender: UIButton) {
        self.ExitUnity()
    }
    @objc func ExitUnity()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopUnity()
        //appDelegate.CloseUnity()
        UnityGetGLViewController().dismiss(animated: true, completion: nil)
        unityView!.removeFromSuperview()
        DispatchQueue.main.async {
            if self.Controller == "Home"
            {
                self.performSegue(withIdentifier: "GoToHomeScreen", sender: self)
            }
            else{
                self.performSegue(withIdentifier: "GoToPreviewScreen", sender: self)
            }
            
        }
    }
    @objc func handleUnityReady() {
        showUnitySubView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SwipeViewController
        {
            destination.isFromUnity = true
        }
        /*if let destination = segue.destination as? TestPreviewCardViewController
        {
            destination.PrevSelectedAnimationCell = PrevSelectedAnimationCell!
            destination.PrevSelectedSongCell = PrevSelectedSongCell!
            destination.PrevSelectedMessageCell = PrevSelectedMessageCell!
            destination.strReceipentName = strRecipientName
            destination.strMomentUrl = strMomentUrl
            destination.strMessage = strMessage
            destination.iARCardID = iARCardID
            print(iARCardID)
        }*/
    }
   

    @objc func showUnitySubView() {
        if let unityView = UnityGetGLView() {
            // insert subview at index 0 ensures unity view is behind current UI view
            //self.view?.insertSubview(unityView)
            self.view.addSubview(unityView)
            unityView.translatesAutoresizingMaskIntoConstraints = false
            let views = ["view": unityView]
            let w = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[view]-20-|", options: [], metrics: nil, views: views)
            let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[view]-50-|", options: [], metrics: nil, views: views)
            view.addConstraints(w + h)
            DisplayMessage()
        }
    }
    /*
     02/06/2018
     Function to pass parameter to Unity
     */
    func DisplayMessage()
    {
        //strAnimationUrl is path tp folder
        let strDataToSend = "\(staticVariables.strARCode),\(staticVariables.strAnimationPath),\(staticVariables.iUserID!),\(staticVariables.bIsVirtual!),\(staticVariables.strSongsPath),\(staticVariables.strVoiceRecordingPath),\(staticVariables.strMessage),\(staticVariables.strAnimationName)"
    //let strDataToSend = "\(strARCode!),\(strAnimationUrl),\(iUserId!),\(bIsVirtual!),\(strStreamingUrl!),\(strVoiceRecording!),\(strMessage!),\(strAnimationName)"
        UnitySendMessage("ARCamera", "ReceiveDataFromAndroid", "\(strDataToSend)")
        print("Data send from iOS\(strDataToSend)")
    }
    
}
