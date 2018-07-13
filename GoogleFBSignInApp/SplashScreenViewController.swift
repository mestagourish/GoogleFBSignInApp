//
//  SplashScreenViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 21/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var imgGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        perform(#selector(SplashScreen), with: nil, afterDelay: 10)
    }
    //Goes to the SwipeViewController (Login and Moment screen with swipe feature)
    @objc func SplashScreen()
    {
       // performSegue(withIdentifier: "FromSplashScreen", sender: self)
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
