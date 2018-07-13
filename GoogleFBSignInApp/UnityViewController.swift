//
//  UnityViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 21/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class UnityViewController: UIViewController {

    static var isUnityLoaded : Bool = false
    var unityView: UIView!
    
    @IBAction func btnExit(_ sender: UIButton) {
        exitUnity()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(exitUnity), name: NSNotification.Name("StopUnity"), object: nil)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //appDelegate.myOrientation = .landscapeRight
            appDelegate.startUnity()
            if (UnityViewController.isUnityLoaded) {
                self.handleUnityReady()
            }
            else {
                NotificationCenter.default.addObserver(self, selector: #selector(handleUnityReady), name: NSNotification.Name("UnityReady"), object: nil)
            }
        }
    }
    
    @objc func handleUnityReady() {
        self.unityView = UnityGetGLView()
        self.view.addSubview(unityView)
        unityView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["view": unityView]
        let w = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[view]-20-|", options: [], metrics: nil, views: views)
        let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[view]-50-|", options: [], metrics: nil, views: views)
        self.view.addConstraints(w + h)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
    }
    
    func exitUnity() {
        //NotificationCenter.default.removeObserver(self)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stopUnity()
        unityView.removeFromSuperview()
        //self.view.sendSubview(toBack: unityView!) // Just to try if GVR accept it. But no way
        
        UnityViewController.isUnityLoaded = true
        //appDelegate.myOrientation = .portrait
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CreateCardScreen", sender: self)
        }
    }

}
