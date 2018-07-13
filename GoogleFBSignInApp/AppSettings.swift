//
//  AppSettings.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 11/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    /*
     11/06/2018
     Url for get and post requesr
     */
    struct Urls {
        
        static let strMomentUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/Moment/GetMoments?"
        static let strARCodeUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/ARCard/GetARCardByCode"
        static let strLoginUrl  : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/Login/LoginRegister"
        static let strOTPConfirmationUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/Login/OTPVerification"
        static let strSongsUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/ARCard/GetSongs?"
        static let strQuotesUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/ARCard/GetQuotes?"
        static let ARBundleUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/ARCard/GenerateARBundle"
        static let strAnimationUrl : String = "http://encowebservice.eerjt4wmjx.us-east-2.elasticbeanstalk.com/rest/ARCard/GetAnimations?"
        
        
    }
    /*
     11/06/2018
     AWS Parameter
     */
    struct bucket {
        static let strBucketName = "encoar-userfiles-mobilehub-1767594688"
        static let strAssetBunldles = "assetbundles/ios"
        static let strVoiceRecordings = "voicerecordings"
    }
    static let animationImage:[String] =
        ["EasterBunny_HipHopDancing","santaclaus_samba"
    ]
    /*
     11/06/2018
     tab bar images for selected items
     */
    static let alImagesNameForSelectedState:[String] = ["songIconSelected","animationIconSelected","quotesIconSelected","audioRecordingIconSelected"]
    //tab bar images for unselected item
    static let alImagesNameForUnSelectedState:[String] = ["songIconNotSelected","animationIconNotSelected","quotesIconNotSelected","audioRecordingIconNotSelected"]
    static let alMessages:[String] =  ["“Have enjoyed getting to know you these last few years...appreciate your great work ethics...Happy birthday”",
    "“My wish for you...may each road lead to where you find happiness...Happy Birthday.”",
    "“Count your life by smiles, not tears. Count your age by friends, not years. Happy birthday!”",
    "“Wishing you a wonderful Christmas filled with happiness and fun”",
    "“May this Christmas brings you love and joy. Seasons Greetings and Happy new year”",
    "“May the light of the diyas guide you on the way to happiness and success. Happy Diwali!!!”",
    "“Spring is arriving with the message that Jesus has risen.Happy Easter”"]
    static var iUserID : Int = 1
    static var iARCardId : Int!
    static let alGIF:[String] = ["TheRock","tenor"]
}
