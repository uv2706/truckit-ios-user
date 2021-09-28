//
//  TruckItSessionHandler.swift
//  My Home Hub
//
//  Created by hb on 28/11/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation

class SessionConstant {
    static let DEVICE_TOKEN: String = "push_device_token"
    static let USER_DATA: String = "user_details"
    static let WS_TOKEN: String = "ws_token"
    static let CANCEL_CHARGER: String = "cancel_charge"
    static let payment_mode: String = "payment_mode"
}

open class TruckItSessionHandler: NSObject {
    
    let applicationDefaults = UserDefaults.standard
    static let shared = TruckItSessionHandler()
    var isRatingAPICall = false

    var userId: String {
        let userDetail = self.getLoggedUserDetails()
        return userDetail?.userId ?? "0"
    }
    
    var userAuthToken: String {
        let userDetail = self.getLoggedUserDetails()
        return userDetail?.authToken ?? "0"
    }
    
    var deviceToken: String {
        if let token = applicationDefaults.value(forKey: SessionConstant.DEVICE_TOKEN) as? String {
            return token
        }
        return ""
    }
    
    var cancelCharge: String {
        if let token = applicationDefaults.value(forKey: SessionConstant.CANCEL_CHARGER) as? String {
            return token
        }
        return "0.00"
    }
    
    func setLoggedUserDetails(userDetail: Login.Authentication.ViewModel) {
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(userDetail)
        applicationDefaults.setValue(encodedData, forKey: SessionConstant.USER_DATA)
        applicationDefaults.synchronize()
    }

    func getLoggedUserDetails() -> Login.Authentication.ViewModel? {
        if let decoded = applicationDefaults.object(forKey: SessionConstant.USER_DATA) as? Data {
            let decoder = JSONDecoder()
            let decodedUser = try? decoder.decode(Login.Authentication.ViewModel.self, from: decoded)
            return decodedUser
        }
        return nil
    }
    
    func removeUserDefaultsWhileLoggedOut() {
        applicationDefaults.removeObject(forKey: SessionConstant.USER_DATA)
        applicationDefaults.synchronize()
        //BLSessionHandler.shared.userId = "0";
    }
    
    func saveDeviceToken(token: String) {
        applicationDefaults.setValue(token, forKey: SessionConstant.DEVICE_TOKEN)
        applicationDefaults.synchronize()
    }
    
    func saveCancelCharge(token: String) {
        applicationDefaults.setValue(token, forKey: SessionConstant.CANCEL_CHARGER)
        applicationDefaults.synchronize()
    }
    
    func savePaymentMode(mode: String) {
        applicationDefaults.setValue(mode, forKey: SessionConstant.payment_mode)
        applicationDefaults.synchronize()
    }
    
    func setWSToken(token: String) {
        applicationDefaults.setValue(token, forKey: SessionConstant.WS_TOKEN)
        applicationDefaults.synchronize()
    }
    
    func getDeviceToken() -> String? {
        if let token = applicationDefaults.value(forKey: SessionConstant.DEVICE_TOKEN) as? String {
            return token
        }
        return ""
    }
    
    func getPaymentMode() -> String? {
        if let token = applicationDefaults.value(forKey: SessionConstant.payment_mode) as? String {
            return token
        }
        return "test"
    }
}
