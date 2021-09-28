//
//  ChangeMobileNumberModels.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.


import UIKit

enum ChangeMobileNumber {
    
    struct Request {
        var mobileNumber: String
    }
    
    class ViewModel: WSResponseData {
        var otp : String?
        
        
        enum CodingKeys: String, CodingKey {
            case otp = "otp"
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            otp = try values.decodeIfPresent(String.self, forKey: .otp)
            
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(otp, forKey: .otp)
        }
    }
}

