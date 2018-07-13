//
//  LaunchScreenViewController.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 21/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var imgGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Entered to load Gif...........")
        /*
         21/06/2018
         calls the Swift+GIF to load the GIF
         */
        imgGif.loadGif(name: "Peacolo_op_2")
        // Do any additional setup after loading the view.
        //delay for GIF to complete
        perform(#selector(SplashScreen), with: nil, afterDelay: 6)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    //Goes to the SwipeViewController (Login and Moment screen with swipe feature)
    @objc func SplashScreen()
    {
        /*
         21/06/2018
         goes to the swipe screen
         */
        performSegue(withIdentifier: "FromLaunchScreen", sender: self)
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
