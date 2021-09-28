//
//  OngoingDetailsInteractor.swift
//  PickUpUser
//
//  Created by hb on 23/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OngoingDetailsBusinessLogic {
    func pickUpDetail(request: PickUpDetail.Request, showLoader: Bool)
}

protocol OngoingDetailsDataStore {
    
}

class OngoingDetailsInteractor: OngoingDetailsBusinessLogic, OngoingDetailsDataStore {
    var presenter: OngoingDetailsPresentationLogic?
    var worker: OngoingDetailsWorker?
    
    func pickUpDetail(request: PickUpDetail.Request, showLoader: Bool) {
        worker = OngoingDetailsWorker()
        worker?.details(request: request,showLoader: showLoader, completionHandler: { (response, message, success) in
            self.presenter?.presentDetails(response: response, message: message ?? "", success: success ?? "")
        })
    }
}
