//
//  PickUpDetailAPIRouter.swift
//  PickUpUser
//
//  Created by hb on 17/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum PickUpDetailAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case pickUpList(request: Deliveries.Request)
    case pickUpDetails(request: PickUpDetail.Request)
    case offerList(request: Offers.Request)
    case acceptRejectOffer(request: AcceptRejectOffer.Request)
    case addTip(request: Tip.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .pickUpList:
            return "/delivery_list_for_user"
        case .pickUpDetails:
            return "/pick_up_details_for_driver"
        case .offerList:
            return "/offer_listing"
        case .acceptRejectOffer:
            return "/accept_reject_offer"
        case .addTip:
            return "/add_tip_to_pickup"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .pickUpList(let req):
            return [
             //   "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "delivery_type": req.type
            ]
        case .pickUpDetails(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": req.pickUpId
            ]
        case .offerList(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": req.pickUpId
            ]
        case .acceptRejectOffer(let req):
            return [
           //     "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "offer_id": req.offerId,
                "user_stripe_id": TruckItSessionHandler.shared.getLoggedUserDetails()?.stripeId ?? "",
                "card_id": req.cardId,
                "offer_type": req.type
            ]
        case .addTip(let req):
            return [
             //   "user_id": TruckItSessionHandler.shared.userId,
                //                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": req.pickupId,
                "user_stripe_id": TruckItSessionHandler.shared.getLoggedUserDetails()?.stripeId ?? "",
                "card_id": req.stripeCardId,
                "tip_amount": req.tipAmount
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
