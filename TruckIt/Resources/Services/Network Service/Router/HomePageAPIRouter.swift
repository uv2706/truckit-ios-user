//
//  HomePageAPIRouter.swift
//  Udecide
//
//  Created by hb on 17/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum HomePageAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    case getNearPickUp(request: Home.Request)
    case getConfig
    case addRating
    case editProfile(request: EditProfile.Request)
    
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .getNearPickUp:
            return "/get_near_by_drivers"
        case .getConfig:
            return "/get_config_parameters"
        case .addRating:
            return "/add_rating_to_existing_pickup"
        case .editProfile:
            return "/edit_profile"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getNearPickUp(let request):
            return [
                "latitude":  request.latitude ,
                "longitude": request.longitude,
            ]
        case .getConfig:
            return nil
        case .addRating:
            return nil
        case .editProfile(let request):
            return [
                "user_profile": request.userProfile,
                "first_name": request.firstName,
                "phone_number": request.PhoneNumber,
                "last_name": request.lastName,
                "address": request.address,
                "latitude": request.lat,
                "longitude": request.long,
                "about_me": request.aboutMe,
                "apt_no": request.AptNp
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
            arrMultiPart.append(MultiPartData(fileName: request.profileName, data: request.userProfile, paramKey: "user_profile", mimeType: request.profileName.fileExtension(), urlString: nil, fileKey: "user_profile"))
            return arrMultiPart
            
        default:
            return nil
            
        }
    }
}
