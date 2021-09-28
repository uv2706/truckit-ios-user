//
//  PastPickUpDetailWorker.swift
//  PickUpDriver
//
//  Created by hb on 11/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class PastPickUpDetailWorker {
    func details(request: PickUpDetail.Request, completionHandler: @escaping (PickUpDetail.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: PickUpDetailAPIRouter.pickUpDetails(request: request), showLoader: true) { (responce: WSResponse<PickUpDetail.ViewModel>?, error: NetworkError?) in
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
