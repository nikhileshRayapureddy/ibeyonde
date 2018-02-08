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
                        iBeyondeUserDefaults.setUserName(object: username)
                        iBeyondeUserDefaults.setPassword(object: password)
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
    public func registerWithUsername(username:String,email:String,password:String,phone:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {

        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "https://app.ibeyonde.com/api/iot.php?view=register&user_name=\(username)&user_email=\(email)&user_password_new=\(password)&user_password_repeat=\(password)&user_phone=\(phone)"
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
    public func getDeviceList(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@app.ibeyonde.com/api/iot.php?view=devicelist"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrDevices = [DeviceListBO]()
                    for dict in data
                    {
                        let bo = DeviceListBO()
                        if let code = dict["uuid"] as? String
                        {
                           bo.uuid = code
                        }
                        arrDevices.append(bo)
                    }
                    successMessage(arrDevices)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    public func getImagesForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@app.ibeyonde.com/api/iot.php?view=lastalerts&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String]]
                {
                    var arrImages = [listImageBO]()
                    for item in data
                    {
                        let bo = listImageBO()
                        bo.strImage = item[0]
                        bo.strTime = item[1]
                        arrImages.append(bo)
                    }
                    successMessage(arrImages)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getLatestImageForList(strID : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@app.ibeyonde.com/api/iot.php?view=lastalert&uuid=\(strID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [String]
                {
                    if data.count > 1
                    {
                        let bo = listImageBO()
                        bo.strImage = data[0]
                        bo.strTime = data[1]
                        successMessage(bo)
                    }
                    else
                    {
                        failureMessage("No Data Found")
                    }
                    
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getHistoryWith(strID : String,strDate : String,strTime : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "https://\(iBeyondeUserDefaults.getUserName()):\(iBeyondeUserDefaults.getPassword())@app.ibeyonde.com/api/iot.php?view=history&uuid=\(strID)&date=\(strDate)&time=\(strTime)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrImages = [listImageBO]()
                    for dict in data
                    {
                        let bo = listImageBO()
                        if let datetime = dict["datetime"] as? String
                        {
                            bo.strTime = datetime
                        }
                        if let url = dict["url"] as? String
                        {
                            bo.strImage = url
                        }
                        arrImages.append(bo)
                    }
                    successMessage(arrImages)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }

}

