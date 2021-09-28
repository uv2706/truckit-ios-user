//
//  AddPickupAPIRouter.swift
//  PickUpUser
//
//  Created by hb on 13/06/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum AddPickupAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case getSize
    case updateStatus(request: Process.Request)
    case createPickup(request: AddPickup.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .getSize:
            return "/pick_up_size_list"
        case .updateStatus:
            return "/update_pickUp_status"
        case .createPickup:
            return "/create_pick_up"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getSize:
            return [:]
             //   "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken
         //   ]
        case .updateStatus(let req):
            return [
              //  "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "pickup_id": req.pickUpId,
                "latitude": req.lat,
                "longitude": req.long,
                "status": req.status
            ]
        case .createPickup(let request):
           return  [
              //  "user_id"    : TruckItSessionHandler.shared.userId,
                "pickup_location"    : request.pickLocation,
                "pickup_latitude"    : request.pickLat,
                "pickup_longitude" : request.pickLong,
                "size_id"    : request.sizeId,
                "pickup_contact_name"    : request.pickContactName,
                "pickup_contact_number"    : request.pickContactNum,
                "pickup_at"    : request.pickTime,
                "dropoff_location"    : request.dropLocation,
                "dropoff_latitude"    : request.dropLat,
                "dropoff_longitude"    : request.dropLong,
                "dropoff_at"    : request.dropTime,
                "dropoff_contact_name"    : request.dropContactName,
                "dropoff_contact_number" : request.dropContactNum,
                "estimated_amount"    : request.estimatedAmount,
                "images_count"    : "\(request.imageArray.count)",
                "helper_required": request.helper_required
                
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
        case .createPickup(let request):
            var arrMultiPart = [MultiPartData]()
            
            var imageData = [Data]()
            for pickedImage in request.imageArray {
                let data = pickedImage.jpegData(compressionQuality: 0.5)
                imageData.append(data!)
            }
            
            for count in 0...request.imageArray.count - 1 {
                arrMultiPart.append(MultiPartData(fileName: "image_\(count + 1).jpg", data: imageData[count] as Data, paramKey: "image_\(count + 1)", mimeType: "image/jpg", urlString: nil, fileKey: "image_\(count + 1)"))
            }
            return arrMultiPart
            
        case .getSize:
            return nil
        case .updateStatus:
            return nil
        }
    }
}
