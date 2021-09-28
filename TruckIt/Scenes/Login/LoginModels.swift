//
//  LoginModels.swift
//  Udecide
//
//  Created by hb on 09/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Login {
    // MARK: Use cases
    enum Authentication {
        struct Request {
            var phone: String
            var password: String
            var socialLoginId: String
            var socialLoginType: String
        }
        
        class ViewModel: WSResponseData {
            var userId: String?
            var firstName : String?
            var lastName : String?
            var mobileNo : String?
            var email : String?
            var userProfile : String?
            var authToken : String?
            var userType : String?
            var status : String?
            var socialLoginType : String?
            var socialLoginId: String?
            var address: String?
            var lat: String?
            var long: String?
            var aboutMe: String?
            var aptNo: String?
             var stripeId: String?
            
            enum CodingKeys: String, CodingKey {
                case user_id
                case first_name
                case last_name
                case mobile_no
                case email
                case user_profile
                case auth_token
                case user_type
                case status
                case social_login_type
                case social_login_id
                case address
                case latitude
                case longitude
                case about_me
                case apt_no
                case stripe_id
            }
            
            required init(from decoder: Decoder) throws {
                try super.init(from: decoder)
                let values = try decoder.container(keyedBy: CodingKeys.self)
                userId = try values.decodeIfPresent(String.self, forKey: .user_id)
                firstName = try values.decodeIfPresent(String.self, forKey: .first_name)
                lastName = try values.decodeIfPresent(String.self, forKey: .last_name)
                mobileNo = try values.decodeIfPresent(String.self, forKey: .mobile_no)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                userProfile = try values.decodeIfPresent(String.self, forKey: .user_profile)
                authToken = try values.decodeIfPresent(String.self, forKey: .auth_token)
                userType = try values.decodeIfPresent(String.self, forKey: .user_type)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                socialLoginType = try values.decodeIfPresent(String.self, forKey: .social_login_type)
                socialLoginId = try values.decodeIfPresent(String.self, forKey: .social_login_id)
                address = try values.decodeIfPresent(String.self, forKey: .address)
                lat = try values.decodeIfPresent(String.self, forKey: .latitude)
                long = try values.decodeIfPresent(String.self, forKey: .longitude)
                aboutMe = try values.decodeIfPresent(String.self, forKey: .about_me)
                aptNo = try values.decodeIfPresent(String.self, forKey: .apt_no)
                stripeId = try values.decodeIfPresent(String.self, forKey: .stripe_id)
            }
            
            public override func encode(to encoder: Encoder) throws {
                try super.encode(to: encoder)
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(userId, forKey: .user_id )
                try container.encode(firstName, forKey: .first_name)
                try container.encode(lastName, forKey: .last_name)
                try container.encode(mobileNo, forKey: .mobile_no)
                try container.encode(email, forKey: .email)
                try container.encode(userProfile, forKey: .user_profile)
                try container.encode(authToken, forKey: .auth_token)
                try container.encode(userType, forKey: .user_type)
                try container.encode(status, forKey: .status)
                try container.encode(socialLoginType, forKey: .social_login_type)
                try container.encode(socialLoginId, forKey: .social_login_id)
                try container.encode(address, forKey: .address)
                try container.encode(lat, forKey: .latitude)
                try container.encode(long, forKey: .longitude)
                try container.encode(aboutMe, forKey: .about_me)
                try container.encode(aptNo, forKey: .apt_no)
                try container.encode(stripeId, forKey: .stripe_id)
            }
        }
    }
}
