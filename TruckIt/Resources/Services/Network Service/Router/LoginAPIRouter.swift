//
//  LoginAPIRouter.swift
//  PatientData
//
//  Created by hb on 28/03/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum LoginAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    case login(request: Login.Authentication.Request)
    case signUp(request: SignUp.Request)
    case forgotPassword(request: ForgotPassword.Request)
    case stateList
    case logout
    case deleteAccount
    case checkUniqueUser(request: CheckUniqueUSer.Request)
    case updateToken(request : String)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .login:
            
            //downlaod main
        return "/user_login_v1"
            
            //new
           // return "/user_login"
        case .signUp:
            //downlaod main
            return "/user_sign_up_v1"
            
            //new
            //return "/user_sign_up"
        case .forgotPassword:
            return "/forgot_password"
        case .stateList:
            return "/states_list"
        case .logout:
            return "/logout"
        case .deleteAccount:
            return "/delete_account"
        case .checkUniqueUser:
            return "/check_unique_user_v1"
        case .updateToken:
            return "/update_device_token"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let request):
            return [
                "social_login_id": request.socialLoginId,
                "phone_number": request.phone,
                "user_password": request.password,
                "api_version": "1.1",
                "social_login_type": request.socialLoginType,
                "device_token": TruckItSessionHandler.shared.deviceToken,
                "device_type": AppConstants.platform,
                "device_os": AppConstants.os_version,
                "user_type": "user"
            ]
        case .signUp(let request):
            return [
                "user_email": request.email,
                "first_name": request.firstName,
                "user_password": request.password,
                "api_version": "1.1",
                "social_login_type": request.socialLoginType,
                "social_login_id": request.socialLoginId,
                "profile_type": request.profileType,
                "last_name": request.lastName,
                "phone_number": request.phoneNumber,
                "device_token": TruckItSessionHandler.shared.deviceToken,
                "device_type": AppConstants.platform,
                "device_os": AppConstants.os_version,
                "address": request.address,
                "latitude": request.lat,
                "longitude": request.long,
                "about_me": request.aboutMe,
                "apt_no": request.aptNo
            ]
        case .forgotPassword(let request):
            return [
                "mobile_number": request.mobile,
                "user_type": "user"
            ]
        case .logout:
            return [:]
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken
          //  ]
        case .deleteAccount:
            return [
                "user_type": "user"
            ]
        case .checkUniqueUser(let request):
            return [
                "mobile_number": request.phone,
                "user_email": request.email,
                "user_type": "user"
            ]
        case .updateToken(let request):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
                "device_type": AppConstants.platform,
                "device_os": AppConstants.os_version,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "device_token" : request
            ]
        case .stateList:
            return nil
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
        case .signUp(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: ".\(request.profileType)", data: request.userProfile, paramKey: "user_profile", mimeType: request.profileType, urlString: nil, fileKey: "user_profile"))
            return arrMultiPart
            
        case .forgotPassword, .login, .stateList, .logout, .deleteAccount, .checkUniqueUser, .updateToken  :
            return nil
        }
    }
}
