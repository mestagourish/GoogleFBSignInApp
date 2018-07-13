//
//  ApiServiceMethod.swift
//  GoogleFBSignInApp
//
//  Created by Snehal on 11/06/18.
//  Copyright © 2018 Edot. All rights reserved.
//
import UIKit
import Foundation
import Alamofire

struct Moment: Decodable {
    let `Type` : String!
    let ImageUrl : String!
    let MomentID : Int!
    let ARCardID : Int!
}
struct Songs: Decodable {
    let SongID : Int!
    let StreamingUrl : String!
    let MomentID : Int!
    let Name : String!
    let Artist : String!
    let Album : String!
    /*
    "Price": 0,
    "CreatedBy": 0,
    "CreatedOn": null,
    "UpdatedOn": null
     */
}
struct Quotes: Decodable {
    let QuoteID : Int!
    let MomentID : Int!
    let Message : String!
    /*
    "Type": null,
    "CreatedBy": 0,
    "CreatedOn": null,
    "UpdatedOn": null
     */
}
struct Animation: Decodable {
    let AnimationID : Int!
    let MomentID : Int!
    let `Type` : Int!
    let Name : String!
    let AnimationUrl : String!
    let Price : Int!
    /*"CreatedBy": 0,
    "CreatedOn": null,
    "UpdatedOn": null*/
}
class ApiServiceMethod{
    /*
     12/06/2018
     function to create an http post rrequest
     05/07/2018
     added a response object in the completion handler
     */
    class func PostRequest(serviceUrl:URL,parameterDictionary: [String:Any],completionHandler: @escaping (_ jsonData: Any,_ error:Bool) -> Void) {
        //var request = URLRequest(url: serviceUrl)
        var request = URLRequest(url: serviceUrl, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5.0)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options:.prettyPrinted)
        print(parameterDictionary)
        request.httpBody = httpBody
        //let sessionConfig = URLSessionConfiguration.default
        //sessionConfig.timeoutIntervalForRequest = 30.0
        //sessionConfig.timeoutIntervalForResource = 60.0
        //let session = URLSession(configuration: sessionConfig)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do{
                    //completionHandler(data!,false)
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(dataString!)
                    let strData = dataString?.replacingOccurrences(of: "\"", with: "")
                    //print(str.replacingOccurrences(of: "\"", with: "")) // Hello
                    if (strData?.isEqual("OK"))!
                    {
                        print(strData!)
                        completionHandler(dataString!,false)
                    }
                    else
                    {
                     let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                     completionHandler(json,false)
                    }
                    
                }catch let jsonError{
                    print(jsonError)
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Somthing Went Wrong", view: UIApplication.topViewController()!)
                    completionHandler(["Nil"],true)
                    return
                }
            }
            else
            {
                completionHandler(["Nil"],false)
                DispatchQueue.main.async {
                    
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Somthing Went Wrong", view: UIApplication.topViewController()!)
                    return
                }
            }
            
        }
        task.resume()
    }
    /*class func GetRequest(url:URL,completionHandler: @escaping (_ images:[Any])-> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil{
                do {
                    var images : [Moment] = []
                    images = try JSONDecoder().decode([Moment].self, from: data!)
                    completionHandler(images)
                }catch {
                    print("parse error")
                }
            }
            else
            {
                //self.alert?.CreateAlert(tittle: "Alert", message: "No Internet")
            }
            }.resume()
    }*/
    /*
     12/06/2018
     function to create an http get rrequest
     */
    class func GetRequest(url:URL,iDataToDecode : Int,completionHandler: @escaping (_ images:[Any],_ error: Bool)-> Void) {
        var getRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        getRequest.httpMethod = "GET"
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: getRequest) { (data, response, error) in
            if error == nil{
                do {
                    if iDataToDecode == 0
                    {
                        var Response : [Moment] = []
                        Response = try JSONDecoder().decode([Moment].self, from: data!)
                        completionHandler(Response,false)
                    }
                    else if iDataToDecode == 1
                    {
                        var Response : [Songs] = []
                        Response = try JSONDecoder().decode([Songs].self, from: data!)
                        completionHandler(Response,false)
                    }
                    else if iDataToDecode == 2
                    {
                        var Response : [Quotes] = []
                        Response = try JSONDecoder().decode([Quotes].self, from: data!)
                        completionHandler(Response,false)
                    }
                    else if iDataToDecode == 3
                    {
                        var Response : [Animation] = []
                        Response = try JSONDecoder().decode([Animation].self, from: data!)
                        completionHandler(Response,false)
                    }
                }catch {
                    print("Parse Error")
                    completionHandler(["Nil"],true)
                    return
                }
            }
            else
            {
                completionHandler(["Nil"],true)
                DispatchQueue.main.async {
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Somthing Went Wrong", view: UIApplication.topViewController()!)
                }
                print("service is off")
                return
            }
            }.resume()
        }
        /*
        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if error == nil{
                do {
                    if iDataToDecode == 0
                    {
                        var Response : [Moment] = []
                        Response = try JSONDecoder().decode([Moment].self, from: data!)
                        completionHandler(Response)
                    }
                    else if iDataToDecode == 1
                    {
                        var Response : [Songs] = []
                        Response = try JSONDecoder().decode([Songs].self, from: data!)
                        completionHandler(Response)
                    }
                    else if iDataToDecode == 2
                    {
                        var Response : [Quotes] = []
                        Response = try JSONDecoder().decode([Quotes].self, from: data!)
                        completionHandler(Response)
                    }
                }catch {
                    print("Parse Error")
                    return
                }
            }
            else
            {
                DispatchQueue.main.async {
                    CreateAlerts.DisplayAlert(tittle: "Alert", message: "Somthing Went Wrong", view: UIApplication.topViewController()!)
                }
                print("service is off")
                return
            }
            }.resume()
}*/
}
/*
 06/07/2018
 class to check for internet connectivity
 if connected then returns true
 else retun false
 */
class Conectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
extension UIApplication {
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
/*
 
 */
