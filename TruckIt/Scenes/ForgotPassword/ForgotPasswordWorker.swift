//
//  ForgotPasswordWorker.swift
//  Udecide
//
//  Created by hb on 11/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ForgotPasswordWorker {
    func forgotPassword(request: ForgotPassword.Request,completionHandler: @escaping ([ForgotPassword.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: LoginAPIRouter.forgotPassword(request: request), showLoader: true) { (responce: WSResponse<ForgotPassword.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.errorMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
    
}
