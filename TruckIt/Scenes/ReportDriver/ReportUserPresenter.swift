//
//  ReportUserPresenter.swift
//  PickUpUser
//
//  Created by hb on 03/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReportUserPresentationLogic {
    func presentReportReason(response: [ReportReason.ViewModel]?, message: String, success: String)
    func presentReport(message: String, success: String)
}

class ReportUserPresenter: ReportUserPresentationLogic {
    weak var viewController: ReportUserDisplayLogic?
    
    func presentReportReason(response: [ReportReason.ViewModel]?, message: String, success: String) {
        self.viewController?.didReceiveReportReason(response: response, message: message, success: success)
    }
    
    func presentReport(message: String, success: String) {
        self.viewController?.didReceiveReport(message: message, success: success)
    }
}
