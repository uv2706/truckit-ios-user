//
//  DeliveriesModels.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Deliveries {
    struct Request {
        var type: String
    }
    
    class ViewModel: WSResponseData {
        var pickupId: String?
        var userId: String?
        var pickUpLocation : String?
        var pickUpLatitude : String?
        var pickUpLongitude: String?
        var sizeId: String?
        var pickUpAt : String?
        var pickUpContactName : String?
        var pickUpContactNumber: String?
        var dropOffLocation: String?
        var dropOffLatitude : String?
        var dropOffLongitude : String?
        var dropOffAt: String?
        var dropContactName: String?
        var dropContactNumber : String?
        var estimatedAmount : String?
        var status: String?
        var driverId: String?
        var pickUpStatus : String?
        var offerCount: String?
        var driverName: String?
        var driverProfile: String?
        var offeramount: String?
        
        enum CodingKeys: String, CodingKey {
            case pickup_id
            case user_id
            case pick_up_location
            case pick_up_latitude
            case pick_up_longitude
            case size_id
            case pick_up_at
            case pick_up_contact_name
            case pick_up_contact_number
            case drop_off_location
            case drop_off_latitude
            case drop_off_longitude
            case drop_off_at
            case drop_contact_name
            case drop_contact_number
            case estimated_amount
            case status
            case driver_id
            case pick_up_status
            case offer_count
            case driver_name
            case driver_profile
            case offer_amount
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            pickupId = try values.decodeIfPresent(String.self, forKey: .pickup_id)
            userId = try values.decodeIfPresent(String.self, forKey: .user_id)
            pickUpLocation = try values.decodeIfPresent(String.self, forKey: .pick_up_location)
            pickUpLatitude = try values.decodeIfPresent(String.self, forKey: .pick_up_latitude)
            pickUpLongitude = try values.decodeIfPresent(String.self, forKey: .pick_up_longitude)
            sizeId = try values.decodeIfPresent(String.self, forKey: .size_id)
            pickUpAt = try values.decodeIfPresent(String.self, forKey: .pick_up_at)
            pickUpContactName = try values.decodeIfPresent(String.self, forKey: .pick_up_contact_name)
            pickUpContactNumber = try values.decodeIfPresent(String.self, forKey: .pick_up_contact_number)
            dropOffLocation = try values.decodeIfPresent(String.self, forKey: .drop_off_location)
            dropOffLatitude = try values.decodeIfPresent(String.self, forKey: .drop_off_latitude)
            dropOffLongitude = try values.decodeIfPresent(String.self, forKey: .drop_off_longitude)
            dropOffAt = try values.decodeIfPresent(String.self, forKey: .drop_off_at)
            dropContactName = try values.decodeIfPresent(String.self, forKey: .drop_contact_name)
            dropContactNumber = try values.decodeIfPresent(String.self, forKey: .drop_contact_number)
            estimatedAmount = try values.decodeIfPresent(String.self, forKey: .estimated_amount)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            driverId = try values.decodeIfPresent(String.self, forKey: .driver_id)
            pickUpStatus = try values.decodeIfPresent(String.self, forKey: .pick_up_status)
            offerCount = try values.decodeIfPresent(String.self, forKey: .offer_count)
            driverName = try values.decodeIfPresent(String.self, forKey: .driver_name)
            driverProfile = try values.decodeIfPresent(String.self, forKey: .driver_profile)
            offeramount = try values.decodeIfPresent(String.self, forKey: .offer_amount)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(pickupId, forKey: .pickup_id )
            try container.encode(userId, forKey: .user_id )
            try container.encode(pickUpLocation, forKey: .pick_up_location)
            try container.encode(pickUpLatitude, forKey: .pick_up_latitude )
            try container.encode(pickUpLongitude, forKey: .pick_up_longitude )
            try container.encode(sizeId, forKey: .size_id )
            try container.encode(pickUpAt, forKey: .pick_up_at)
            try container.encode(pickUpContactName, forKey: .pick_up_contact_name)
            try container.encode(pickUpContactNumber, forKey: .pick_up_contact_number )
            try container.encode(dropOffLocation, forKey: .drop_off_location )
            try container.encode(dropOffLatitude, forKey: .drop_off_latitude)
            try container.encode(dropOffLongitude, forKey: .drop_off_longitude )
            try container.encode(dropOffAt, forKey: .drop_off_at )
            try container.encode(dropContactName, forKey: .drop_contact_name )
            try container.encode(dropContactNumber, forKey: .drop_contact_number)
            try container.encode(estimatedAmount, forKey: .estimated_amount )
            try container.encode(status, forKey: .status )
            try container.encode(driverId, forKey: .driver_id )
            try container.encode(pickUpStatus, forKey: .pick_up_status)
            try container.encode(offerCount, forKey: .offer_count)
            try container.encode(driverName, forKey: .driver_name)
            try container.encode(driverProfile, forKey: .driver_profile)
            try container.encode(offeramount, forKey: .offer_amount)
        }
    }
}
