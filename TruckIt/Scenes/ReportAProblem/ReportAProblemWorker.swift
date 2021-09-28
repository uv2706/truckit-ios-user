//
//  ReportAProblemWorker.swift
//  Udecide
//
//  Created by hb on 17/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ReportAProblemWorker {
    func reportAProblem(request: ReportAProblem.Request,completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: StaticPageAPIRouter.reportAProblem(request: request), showLoader: true) { (responce: WSResponse<ForgotPassword.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
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
