//
//  ProcessModels.swift
//  PickUpUser
//
//  Created by hb on 18/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Process {
    struct Request {
        var pickUpId: String
        var lat: String
        var long: String
        var status: String
    }
    
    class ViewModel: WSResponseData {
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}
