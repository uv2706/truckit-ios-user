//
//  PaymentAPIRouter.swift
//  PickUpUser
//
//  Created by hb on 01/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum PaymentAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case savePaymentCard(request: AddPaymentCard.Request)
    case cardList
    case removeCard(request: RemoveCard.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .savePaymentCard:
            return "/save_card"
        case .cardList:
            return "/customer_stripe_cards"
        case .removeCard:
            return "/remove_card_from_stripe"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .cardList:
            return [
             //   "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "user_stripe_id": TruckItSessionHandler.shared.getLoggedUserDetails()?.stripeId ?? ""
            ]
        case .removeCard(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "user_stripe_id": TruckItSessionHandler.shared.getLoggedUserDetails()?.stripeId ?? "",
                "card_id": req.cardId
            ]
        case .savePaymentCard(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.getLoggedUserDetails()?.authToken ?? "",
                "user_stripe_id": TruckItSessionHandler.shared.getLoggedUserDetails()?.stripeId ?? "",
                "stripe_token_id": req.stripeToken
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
