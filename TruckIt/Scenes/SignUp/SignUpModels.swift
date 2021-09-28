//
//  SignUpModels.swift
//  Udecide
//
//  Created by hb on 11/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SignUp {
    struct Request {
        var email: String
        var password: String
        var socialLoginId: String
        var socialLoginType: String
        var firstName: String
        var lastName: String
        var userProfile: Data
        var profileType: String
        var phoneNumber: String
        var socialProfileURl: String
        var address: String
        var lat: String
        var long: String
        var aboutMe: String
        var aptNo: String
    }
    
    class ViewModel: WSResponseData {
        var userId : String?
        var userEmail : String?
        var authToken : String?
        var userProfile : String?
        var emailVerified : String?
        var status : String?
        var city : String?
        var zipCode : String?
        var location : String?
        var stateId: String?
        var firstName: String?
        var lastName: String?
        var state: String?
        var phoneNumber: String?
        
        enum CodingKeys: String, CodingKey {
            case user_id
            case user_email
            case auth_token
            case user_profile
            case email_verified
            case status
            case city
            case zip_code
            case location
            case state_id
            case first_name
            case last_name
            case state
            case phone_number
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            userId = try values.decodeIfPresent(String.self, forKey: .user_id)
            userEmail = try values.decodeIfPresent(String.self, forKey: .user_email)
            authToken = try values.decodeIfPresent(String.self, forKey: .auth_token)
            userProfile = try values.decodeIfPresent(String.self, forKey: .user_profile)
            emailVerified = try values.decodeIfPresent(String.self, forKey: .email_verified)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            zipCode = try values.decodeIfPresent(String.self, forKey: .zip_code)
            location = try values.decodeIfPresent(String.self, forKey: .location)
            stateId = try values.decodeIfPresent(String.self, forKey: .state_id)
            firstName = try values.decodeIfPresent(String.self, forKey: .first_name)
            lastName = try values.decodeIfPresent(String.self, forKey: .last_name)
            state = try values.decodeIfPresent(String.self, forKey: .state)
            phoneNumber = try values.decodeIfPresent(String.self, forKey: .phone_number)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(userId, forKey: .user_id)
            try container.encode(userEmail, forKey: .user_email)
            try container.encode(authToken, forKey: .auth_token)
            try container.encode(userProfile, forKey: .user_profile)
            try container.encode(emailVerified, forKey: .email_verified)
            try container.encode(status, forKey: .status)
            try container.encode(city, forKey: .city)
            try container.encode(zipCode, forKey: .zip_code)
            try container.encode(location, forKey: .location)
            try container.encode(stateId, forKey: .state_id)
            try container.encode(firstName, forKey: .first_name)
            try container.encode(lastName, forKey: .last_name)
            try container.encode(state, forKey: .state)
            try container.encode(phoneNumber, forKey: .phone_number)
        }
    }
}

enum CheckUniqueUSer {
    struct Request {
        var email: String
        var phone: String
    }
    
    class ViewModel: WSResponseData {
        var otp : String?
        
        enum CodingKeys: String, CodingKey {
            case otp
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



enum StateList {
    class ViewModel: WSResponseData {
        var stateId : String?
        var state : String?
        var stateCode : String?
        var status : String?
        
        enum CodingKeys: String, CodingKey {
            case state_id
            case state
            case state_code
            case status
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            stateId = try values.decodeIfPresent(String.self, forKey: .state_id)
            state = try values.decodeIfPresent(String.self, forKey: .state)
            stateCode = try values.decodeIfPresent(String.self, forKey: .state_code)
            status = try values.decodeIfPresent(String.self, forKey: .status)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(stateId, forKey: .state_id)
            try container.encode(state, forKey: .state)
            try container.encode(stateCode, forKey: .state_code)
            try container.encode(status, forKey: .status)
        }
    }
}