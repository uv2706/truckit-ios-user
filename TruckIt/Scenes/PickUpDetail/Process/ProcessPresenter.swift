//
//  ProcessPresenter.swift
//  PickUpUser
//
//  Created by hb on 18/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProcessPresentationLogic {
    func presentPickUpstatus(message: String, success: String)
    func presentDetails(response: PickUpDetail.ViewModel?, message: String, success: String)
}

class ProcessPresenter: ProcessPresentationLogic {
    weak var viewController: ProcessDisplayLogic?
    
    func presentPickUpstatus(message: String, success: String) {
        self.viewController?.didReceivePickUpstatus(message: message, success: success)
    }
    
    func presentDetails(response: PickUpDetail.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveDetails(response: response, message: message, success: success)
    }
}
