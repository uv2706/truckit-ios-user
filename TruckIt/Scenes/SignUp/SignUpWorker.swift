//
//  SignUpWorker.swift
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

class SignUpWorker {
   
    
    func checkUniqueUser(request: CheckUniqueUSer.Request,completionHandler: @escaping (CheckUniqueUSer.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: LoginAPIRouter.checkUniqueUser(request: request), showLoader: true) { (responce: WSResponse<CheckUniqueUSer.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.dictData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.errorMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
    
    func stateList(completionHandler: @escaping ([StateList.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: LoginAPIRouter.stateList, showLoader: false) { (responce: WSResponse<StateList.ViewModel>?, error: NetworkError?) in
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
