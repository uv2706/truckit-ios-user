//
//  ResetPasswordWorker.swift
//  PickUpUser
//
//  Created by hb on 10/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ResetPasswordWorker {
    
    func resetPassword(request: ResetPassword.Request,completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: EditProfileAPIRouter.resetPassword(request: request), showLoader: true) { (responce: WSResponse<ChangePassword.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let _ = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(error?.errorMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
}
