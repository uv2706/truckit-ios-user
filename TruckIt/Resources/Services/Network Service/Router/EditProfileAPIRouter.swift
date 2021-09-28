//
//  EditProfileAPIRouter.swift
//  Udecide
//
//  Created by hb on 16/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum EditProfileAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case changePassword(request: ChangePassword.Request)
    case editProfile(request: EditProfile.Request)
    case resetPassword(request: ResetPassword.Request)
    case getOtp(request: ChangeMobileNumber.Request)
    case changeMobileNumber(request: VerifyOtp.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .changePassword:
            return "/change_password"
        case .editProfile:
            return "/edit_profile"
        case .resetPassword:
            return "/reset_password"
        case .getOtp:
            return "/otp_verification_v1"
        case .changeMobileNumber:
            return "/change_mobile_number"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .changePassword(let request):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "old_password": request.oldPassword,
                "api_version": "1.1",
                "new_password": request.newPassword
            ]
        case .editProfile(let request):
            return [
                "user_profile": request.userProfile,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "first_name": request.firstName,
                "phone_number": request.PhoneNumber,
                "last_name": request.lastName,
                "address": request.address,
                "latitude": request.lat,
                "longitude": request.long,
                "about_me": request.aboutMe,
                "apt_no": request.AptNp
            ]
            
        case .resetPassword(let request):
            return [
            //    "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "new_password": request.newPassword,
                "mobile_number": request.mobileNumber,
                "api_version": "1.1",
                "reset_key": request.resetKey
            ]
        case .getOtp(let request):
            return [
           //     "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "mobile_number": request.mobileNumber,
                "user_type": "user"
            ]
        case .changeMobileNumber(let request):
            return [
             //   "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "new_mobile_number": request.mobile,
                "user_type": "user"
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded","AUTHTOKEN": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? ""]
    }
    
    var files: [MultiPartData]? {
        switch self {
        case .editProfile(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: request.profileName, data: request.userProfile, paramKey: "user_profile", mimeType: request.profileName.fileExtension(), fileKey: "user_profile"))
            return arrMultiPart
            
        case .changePassword, .resetPassword, .getOtp, .changeMobileNumber   :
            return nil
            
        }
    }
}
