//
//  GetARCode.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 09/07/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import Foundation
import UIKit
class GetARCode {
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
