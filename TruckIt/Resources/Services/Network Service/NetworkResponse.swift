//
//  NetworkResponse.swift
//  My Home Hub
//
//  Created by hb on 28/09/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
public enum NetworkResponse<Model: Codable> {
    case failure(NetworkError)
    case success(Model)
}

// TODO: - add customer response handler to its own class
// { "success": "success" }
// { "error": "Can't found cart with order #799" }
public typealias SuccessReponseDictionary = [String: String]
