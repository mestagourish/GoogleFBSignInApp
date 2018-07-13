//
//  ActivityLoader.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 06/07/18.
//  Copyright © 2018 Edot. All rights reserved.
//
import UIKit
import Foundation
/*
 06/07/2018
 creates an object of UIActivity Indicator (Loader)
 */
var activityLoader : UIActivityIndicatorView = {
    let loader = UIActivityIndicatorView()
    loader.translatesAutoresizingMaskIntoConstraints = false
    loader.hidesWhenStopped = true
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    return loader
}()

class ActivityLoader {
    /*
     06/07/2018
     Function to start the animation on the calling viewController
     */
    class func StartAnimating(view : UIView){
        view.addSubview(activityLoader)
        activityLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityLoader.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        activityLoader.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityLoader.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //activityLoader.alignmentRect(forFrame: CGRect(x: 180, y: 500, width: 50, height: 50))
        //activityLoader.UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))
        activityLoader.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    /*
     06/07/2018
     // Function Stops the circular Loader and starts the user interaction with screen
     */
    
    class func StopAnimating(view : UIView) {
        //when dealing with UI DispatchQueue.main.async needs to used
        DispatchQueue.main.async {
            activityLoader.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}
