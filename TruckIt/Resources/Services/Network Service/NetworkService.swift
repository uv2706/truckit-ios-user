//
//  NetworkService.swift
//  My Home Hub
//
//  Created by hb on 28/09/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkProtocol {
     static func dataRequest<Model: WSResponseData>(with request: RouterProtocol, showLoader: Bool, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void)
  
}

final class NetworkService {
    private init() {}

    static let boundaryConstant = "aRandomBoundary1837440"

    private static let manager: SessionManager = { () -> SessionManager in
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
}

extension NetworkService: NetworkProtocol {
    
   
    
    static func dataRequest<Model: WSResponseData>(with inputRequest: RouterProtocol, showLoader: Bool, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            completionHandler(nil, .requestErrorMessageWithStatusCode(errorMessage: AlertMessage.networkConnection))
            return
        }
        
        
		if let inputParam = inputRequest.parameters {
            if showLoader {
                AppConstants.appDelegate.showIndicator()
            }
		}
		
        do {
            _ = try inputRequest.asURLRequest()
        } catch let requestError {
//			if let inputParam = inputRequest.parameters {
//                if showLoader {
//                    AppConstants.appDelegate.hideIndicator()
//                }
//			}
            
            if showLoader {
                AppConstants.appDelegate.hideIndicator()
            }
				
            completionHandler(nil, .requestError(errorMessage: requestError.localizedDescription))
            return
        }
        manager.upload(multipartFormData: { (multiPartData) in
            var reqParam = inputRequest.parameters ?? [String: Any]()
           
            if let files = inputRequest.files {
                for file in files {
                    if let url = file.urlString {
                        multiPartData.append(url, withName: file.paramKey, fileName: file.fileName, mimeType: file.mimeType)
                        multiPartData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")
                    } else {
                        multiPartData.append(file.data, withName: file.paramKey, fileName: file.fileName, mimeType: file.mimeType)
                    }
                    reqParam[file.paramKey] = "FILE"
                }
            }
            
            print("PRE ENCRYPT : \(reqParam)")
            for (key, value) in reqParam {
                print("\(key) :: \(value)")
                multiPartData.append((value as! NSString).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, with: inputRequest) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                 upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseData(completionHandler: { (response) in
                    let request = response.request
                    let resp = response.response
                    let result = response.result
                    let responseString = String(data: response.data!, encoding: .utf8)
                    let error = result.error as NSError?
                    Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                    if showLoader {
                       AppConstants.appDelegate.hideIndicator()
                    }
                    if let data =  response.data {
                        do {
                            let decoder = JSONDecoder()
                            //decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                            let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                            if decodedValue.setting?.success == "401" {
                                AppConstants.appDelegate.showTopMessage(message: AlertMessage.Logout, type: .Error, displayDuraction: 10)
                                TruckItSessionHandler.shared.removeUserDefaultsWhileLoggedOut()
                                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                                if let nav = storyboard.instantiateInitialViewController() ,nav is UINavigationController {
                                    AppConstants.appDelegate.window?.rootViewController = nav
                                }
                            } else {
                            
                                completionHandler(decodedValue, nil)

                            }
                        } catch  _ {
                            completionHandler(nil, .requestError(errorMessage: NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)))
                        }
                    } else {
                        completionHandler(nil, .other(statusCode: response.response?.statusCode, error: nil))
                    }
                })
            case .failure(let error):
                completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            }
        }
    }
    
    
    
    static func dataRequestNew<Model: WSResponseData>(with inputRequest: RouterProtocol, showHud:Bool = true, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        var finalParams = [String:Any]()
        let aRequestDate = Date()
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        
        //////////
        //        if !(NetworkReachabilityManager()!.isReachable) {
        //            let aVC = AppConstants.appDelegate.window?.rootViewController
        //            aVC?.showTopMessage(message: AlertMessage.InternetError, type: .Error)
        //            return
        //        }
        
        if showHud {
            AppConstants.appDelegate.showIndicator()
        }
        
        do {
            _ = try inputRequest.asURLRequest()
        } catch {
            AppConstants.appDelegate.hideIndicator()
            completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            return
        }
        
        manager.upload(multipartFormData: { (multiPartData) in
            var reqParam = inputRequest.parameters ?? [String: Any]()
            //            if let deviceInfo = inputRequest.deviceInfo {
            //                reqParam = reqParam.merging(deviceInfo) { (_, new) in new }
            //            }
            if let files = inputRequest.files {
                for file in files {
                    multiPartData.append(file.data, withName: file.paramKey, fileName: file.fileName, mimeType: file.mimeType)
                    reqParam[file.paramKey] = "FILE"
                }
            }
            print("PRE ENCRYPT : \(reqParam)")
            //finalParams = ((AppConstants.enableEncryption && AppConstants.enableChecksum) ? encryptedParamsWithCheckSum(params: reqParam) : (AppConstants.enableEncryption ? encryptedParams(params: reqParam) : (AppConstants.enableChecksum ? checkSum(of: reqParam) : reqParam)))
            print("POST ENCRYPT : \(finalParams)")
            for (key, value) in finalParams {
                print("\(key) :: \(value)")
                multiPartData.append(((value as? String)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!)!, withName: key)
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, with: inputRequest) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                //                upload.uploadProgress(closure: { (progress) in
                //                    print(progress)
                //                })
                upload.responseData(completionHandler: { (response) in
                    let request = response.request
                    let resp = response.response
                    let result = response.result
                    let responseString = String(data: response.data!, encoding: .utf8)
                    let error = result.error as NSError?
                    Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                    AppConstants.appDelegate.hideIndicator()
                    
                    let finalResponseData: Data? = response.data
                    
                    if let data = finalResponseData {
                        
                        #if canImport(HBLogger)
                        if responseString?.count ?? 0 > 0 {
                            if resp?.statusCode ?? 0 >= 200 && resp?.statusCode ?? 0 <= 299 {
                                HBLogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: responseString, requestDate: aRequestDate, responseDate: Date())
                            } else {
                                let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                                let aJson = GlobalUtility.shared.json(from: aDict)
                                HBLogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                            }
                        } else {
                            let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                            let aJson = GlobalUtility.shared.json(from: aDict)
                            HBLogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                        }
                        #endif
                        
                        // print("Description")
                        //  print(inputRequest.parameters?.description)
                        
                        do {
                            let decoder = JSONDecoder()
                            //                            decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                            let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                            
                            // Logout user automatically if He/She has activated session on another device
                            if decodedValue.setting?.success == "-3" {
                                AppConstants.appDelegate.hideIndicator()
                                
                            }
                            
                            if decodedValue.setting?.success == "401" {
                                
                                AppConstants.appDelegate.hideIndicator()
                                //UserDefaultsManager.logoutUser()
                                //GlobalUtility.redirectToLogin()
                                
                            }
                            
                            /*if decodedValue.setting?.isValidToken ?? false {
                             completionHandler(decodedValue, nil)
                             } else {
                             // create token again
                             GlobelAPI.createTokenWebserviceRequest(completed: { (success, error) in
                             if success {
                             self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                             } else {
                             completionHandler(nil, error)
                             }
                             })
                             }*/
                            completionHandler(decodedValue, nil)
                        } catch _ {
                            completionHandler(nil, .requestError(errorMessage: NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)))
                        }
                    } else {
                        completionHandler(nil, .requestError(errorMessage: "AlertMessage.NetworkTimeOutError"))
                    }
                })
            case .failure(let error):
                if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                    print("Time Out/Connection Lost Error")
                    //self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                    completionHandler(nil, .requestError(errorMessage: "AlertMessage.NetworkTimeOutError"))
                } else {
                    completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
                }
            }
        }
    }
    
    class func errorMessageBasedOnStatusCode(_ code : Int) -> String
        {
             let afilepath = Bundle.main.path(forResource: "ErrorCode", ofType: "plist")
             var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
             let plistXML = FileManager.default.contents(atPath: afilepath!)!
             var plistData: [String: Any] = [:] //Our data
             
             do {//convert the data to a dictionary and handle errors.
                  plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:Any]
                  
                  var message = ""
                  let aRoot = (plistData["ErrorCode"] as!  [[String : Any]])
                  for aObj in aRoot
                  {
                       if aObj["Code"] as! Int == code
                       {
                            message = aObj["Message"] as! String
                            break
                       }
                  }
                  
                  return message
                  
                  
             } catch {
                  print("error")
             }
             return AlertMessage.defaultError
        }
    
}

