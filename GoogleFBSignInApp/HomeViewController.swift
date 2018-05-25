//
//  HomeViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 22/05/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var lablArCode: UITextField!
    @IBAction func btnOpenCard(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lablArCode.resignFirstResponder()
    }
    @IBAction func btnSendCard(_ sender: UIButton) {
        self.view.endEditing(true)
        self.lablArCode.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
