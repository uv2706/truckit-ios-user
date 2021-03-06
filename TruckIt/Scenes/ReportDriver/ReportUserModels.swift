//
//  ReportUserModels.swift
//  PickUpUser
//
//  Created by hb on 03/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ReportUser {
    struct Request {
        var toId: String
        var reasonId: String
        var description: String
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

enum ReportReason {
    class ViewModel: WSResponseData {
        var reportId: String?
        var reportReason : String?
        var status : String?
        
        private enum CodingKeys: String, CodingKey {
            case report_reason_id
            case reason
            case status
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(reportId, forKey: .report_reason_id)
            try container.encode(reportReason, forKey: .reason)
            try container.encode(status, forKey: .status)
        }
        
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reportId = try values.decodeIfPresent(String.self, forKey: .report_reason_id)
            reportReason = try values.decodeIfPresent(String.self, forKey: .reason)
            status = try values.decodeIfPresent(String.self, forKey: .status)
        }
    }
}
