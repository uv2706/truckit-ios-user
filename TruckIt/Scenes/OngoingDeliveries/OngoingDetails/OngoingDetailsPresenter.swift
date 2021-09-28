//
//  OngoingDetailsPresenter.swift
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

protocol OngoingDetailsPresentationLogic {
    func presentDetails(response: PickUpDetail.ViewModel?, message: String, success: String)
}

class OngoingDetailsPresenter: OngoingDetailsPresentationLogic {
    weak var viewController: OngoingDetailsDisplayLogic?
    func presentDetails(response: PickUpDetail.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveDetails(response: response, message: message, success: success)
    }
}
