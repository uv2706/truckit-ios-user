//
//  PickUpDetailInteractor.swift
//  PickUpUser
//
//  Created by hb on 17/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PickUpDetailBusinessLogic {
    func pickUpDetail(request: PickUpDetail.Request)
}

protocol PickUpDetailDataStore {
    
}

class PickUpDetailInteractor: PickUpDetailBusinessLogic, PickUpDetailDataStore {
    var presenter: PickUpDetailPresentationLogic?
    var worker: PickUpDetailWorker?
    
    func pickUpDetail(request: PickUpDetail.Request) {
        worker = PickUpDetailWorker()
        worker?.details(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentDetails(response: response, message: message ?? "", success: success ?? "")
        })
    }
}
