//
//  CreateAlerts.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 12/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//
import UIKit
import Foundation
var loader : UIActivityIndicatorView = UIActivityIndicatorView (frame : CGRect(x: 180, y: 430, width: 50, height: 50))

/*
 00/00/2018
Class to create an alert windowsss
 */

class CreateAlerts{
    class func DisplayAlert(tittle:String,message:String,view:UIViewController)
    {
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {ACTION in
            alert.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
    }
}
//"Check your Internet Connectivity"
