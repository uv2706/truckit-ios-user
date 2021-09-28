//
//  MessageAPIRouter.swift
//  PickUpDriver
//
//  Created by hb on 18/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum MessageAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case readMessage(request: ReadMessage.Request)
    case cancelPickup(request: CancelPickup.Request)
    case sendMessage(request: SendMessage.Request)
    case getPickupStatus(pickupId: String)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .readMessage:
            return "/read_pickup_messages"
        case .sendMessage:
            return "/send_message"
        case .cancelPickup:
            return "/cancel_a_pickup"
        case .getPickupStatus:
            return "/get_pickup_status"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .readMessage(let request):
            return [
           //     "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": request.pickUpId
            ]
        case .cancelPickup(let request):
            return [
           //     "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": request.pickUpId,
                "cancellation_reason": request.message
            ]
        case .sendMessage(let request):
            return [
            //    "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "puckup_id": request.pickUpId,
                "receiver_id": request.receiverId,
                "message": request.Message
            ]
        case .getPickupStatus(let pickupId):
            return [
          //      "user_id": TruckItSessionHandler.shared.userId,
                "pickup_id": pickupId
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
