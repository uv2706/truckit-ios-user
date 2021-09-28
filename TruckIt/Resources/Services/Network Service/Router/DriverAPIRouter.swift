//
//  DriverAPIRouter.swift
//  PickUpUser
//
//  Created by hb on 02/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum DriverAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case driverDetail(request: DriverProfile.Request)
    case reasonList
    case reportUser(request: ReportUser.Request)
    case giveRating(request: GiveRating.Request)
    case getRatings
    case dontShowRatingPopUp(request: DontShowPopUp.Request)

    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .driverDetail:
            return "/driver_profile"
        case .reasonList:
            return "/report_reason_list"
        case .reportUser:
            return "/report_user"
        case .giveRating:
            return "/give_rating"
        case .getRatings:
            return "/review_rating_list"
        case .dontShowRatingPopUp:
            return "update_rating_flag"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .driverDetail(let req):
            return [
            //    "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "driver_id": req.driverId
            ]
        case .reasonList:
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "type": "user"
            ]
        case .reportUser(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "description": req.description,
                "report_on": req.toId,
                "reason_id": req.reasonId
            ]
        case .giveRating(let req):
            return [
          //      "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "rating": req.rating,
                "to_id": req.toId,
                "pickup_id": req.pickUpId,
                "review": req.review
            ]
        case .getRatings:
            return [
        //        "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "user_type": "driver"
            ]
            
        case .dontShowRatingPopUp(let req):
            return [
                "pickup_id": req.pickUpId,
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
        return nil
    }
}
