//
//  AcceptRejectOfferPresenter.swift
//  PickUpUser
//
//  Created by hb on 19/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AcceptRejectOfferPresentationLogic {
    func presentAcceptRejectOffer(message: String, success: String)
}

class AcceptRejectOfferPresenter: AcceptRejectOfferPresentationLogic {
    weak var viewController: AcceptRejectOfferDisplayLogic?
    
    func presentAcceptRejectOffer(message: String, success: String) {
        self.viewController?.didReceiveAcceptRejectOffer(message: message, success: success)
    }
}
