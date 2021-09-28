//
//  ChangeMobileNumberPresenter.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.


import UIKit

protocol ChangeMobileNumberPresentationLogic {
    func presentOtp(response: ChangeMobileNumber.ViewModel?,message: String, success: String)
}

class ChangeMobileNumberPresenter: ChangeMobileNumberPresentationLogic {
    
    weak var viewController: ChangeMobileNumberDisplayLogic?
    
    func presentOtp(response: ChangeMobileNumber.ViewModel?, message: String, success: String) {
        viewController?.didReceivecOtpResponse(response: response, message: message, success: success)
    }
    
}
