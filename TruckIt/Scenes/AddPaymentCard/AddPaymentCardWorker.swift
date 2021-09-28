//
//  AddPaymentCardWorker.swift
//  ForgetMeKnots
//
//  Created by hb on 23/05/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class AddPaymentCardWorker {
    func addCard(request: AddPaymentCard.Request,completionHandler: @escaping (AddPaymentCard.ViewModel?,_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PaymentAPIRouter.savePaymentCard(request: request), showLoader: true) { (responce: WSResponse<AddPaymentCard.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData,resparray.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray.first, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.errorMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
    
}
