//
//  searchFile.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 13/07/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import Foundation

class searchFile
{
   class func searchForFile(strFileName: String) -> Bool{
        var value : Bool = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let pathComp = url.appendingPathComponent("EncoAR/")
        var strDirectoryLocation = "\((pathComp?.path)!)"
        print("Directory location is \(strDirectoryLocation)")
        if let pathComponent = url.appendingPathComponent("EncoAR/\(strFileName)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("\(strFileName) FILE AVAILABLE AT \(filePath)")
                value = true
            } else {
                print("\(strFileName) FILE NOT AVAILABLE")
                value = false
            }
        } else {
            print("\(strFileName) FILE PATH NOT AVAILABLE")
            value = false
        }
        return value
    }
}
