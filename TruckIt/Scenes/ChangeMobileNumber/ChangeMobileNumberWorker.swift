//
//  ChangeMobileNumberWorker.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.


import UIKit

class ChangeMobileNumberWorker {
    func getOtp(request: ChangeMobileNumber.Request,completionHandler: @escaping ( ChangeMobileNumber.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: EditProfileAPIRouter.getOtp(request: request), showLoader: true) { (responce: WSResponse<ChangeMobileNumber.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.dictData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray , msg, detail.setting?.success)
                } else {
                    completionHandler(nil,detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil,error?.errorMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
}
