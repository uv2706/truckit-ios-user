//
//  SplashWorker.swift
//  Test
//
//  Created by hb on 11/10/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

/// Class for splash API Call
class SplashWorker {
    /// API call for splash API Calls
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
     func versionCheck(completionHandler: @escaping (BackGroundCheck.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
          NetworkService.dataRequest(with: HomePageAPIRouter.getConfig, showLoader: true) { (responce: WSResponse<BackGroundCheck.ViewModel>?, error: NetworkError?) in
               if let detail = responce {
                    if let resparray = detail.arrayData, resparray.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                         completionHandler(resparray.first , msg, detail.setting?.success)
                    } else {
                         completionHandler(nil,detail.setting?.message, detail.setting?.success)
                    }
               } else {
                    completionHandler(nil,error?.errorMessage() ?? AlertMessage.defaultError, "0")
               }
          }
     }
}
