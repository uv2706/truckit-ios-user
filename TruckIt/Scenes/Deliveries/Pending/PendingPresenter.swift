//
//  PendingPresenter.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PendingPresentationLogic {
    func presentPendingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String)
}

class PendingPresenter: PendingPresentationLogic {
    weak var viewController: PendingDisplayLogic?
    
    func presentPendingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceivePendingDeliveries(response: response, message: message, success: success)
    }
}
