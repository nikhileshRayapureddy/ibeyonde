//
//  ServiceLayer.swift
//  TaksyKraft
//
//  Created by Medico Desk on 29/06/17.
//  Copyright © 2017 TaksyKraft. All rights reserved.
//

import UIKit
public enum ParsingConstant : Int
{
    case Login
    case Vists
}
protocol ServiceLayer_Delegate {
    func xlmParsingFinishedWith(_home: String,_reachRank:String)

}
class ServiceLayer: NSObject {
    var callback : ServiceLayer_Delegate!
    let SERVER_ERROR = "Server not responding.\nPlease try after some time."

    public func loginWithUsername(username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(username):\(password)@app.ibeyonde.com/api/iot.php?view=login"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? NSNumber,let message = obj.parsedDataDict["message"] as? String
                {
                    if code == 200
                    {
                        successMessage(message)
                    }
                    else
                    {
                        failureMessage(message)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }

            }
        }
    }
    public func registerWithUsername(username:String,email:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        var params = [String:AnyObject]()
        params["user_name"] = username as AnyObject
        params["user_email"] = email as AnyObject
        params["user_password_new"] = password as AnyObject
        params["user_password_repeat"] = password as AnyObject
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "https://app.ibeyonde.com/api/iot.php?view=register"
        obj.params = params
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? NSNumber,let message = obj.parsedDataDict["message"] as? String
                {
                    if code == 200
                    {
                        successMessage(message)
                    }
                    else
                    {
                        failureMessage(message)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
}

