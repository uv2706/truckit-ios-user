//
//  RouterProtocol.swift
//  My Home Hub
//
//  Created by hb on 23/11/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation
import Alamofire

public protocol RouterProtocol: URLRequestConvertible {

    var method: HTTPMethod { get }
    var baseUrlString: String { get }

    var path: String { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var arrayParameters: [Any]? { get }

    var files: [MultiPartData]? { get }
}

public extension RouterProtocol {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.baseUrlString) else {
            throw(NetworkError.requestError(errorMessage: "Unable to create url"))
        }
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.timeoutInterval = 60.0 * 0.5
//        let contentType = "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        do {
            let req = try URLEncoding.default.encode(request as URLRequestConvertible, with: parameters)
            return req
        } catch let error {
            print("error occured \(error)")
        }
        return request
    }
//
//
//
//        guard let url = URL(string: self.baseUrlString) else {
//            throw(NetworkError.requestError(errorMessage: "Unable to create url"))
//        }
//
//        var request = URLRequest(url: url.appendingPathComponent(path))
//        request.httpMethod = self.method.rawValue
//        request.allHTTPHeaderFields = self.headers
//
//        if let file = self.files, file.count > 0 {
//            let contentType = "multipart/form-data; boundary=\(NetworkService.boundaryConstant)"
//            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        }
//
//        if let parameters = parameters {
//            do {
//                request = try parameterEncoding.encode(request, with: parameters)
//            } catch let encodingError {
//                throw(NetworkError.requestError(errorMessage: "Unable to encode with error: \(encodingError), parameters: \(parameters)"))
//            }
//        } else if let arrayParameters = arrayParameters {
//            do {
//                request = try JSONEncoding.default.encode(request, withJSONObject: arrayParameters)
//            } catch let encodingError {
//                throw(NetworkError.requestError(errorMessage: "Unable to encode with error: \(encodingError), parameters: \(parameters ?? [:])"))
//            }
//        }
//        return request
//    }
    
    var arrayParameters: [Any]? {
        return nil
    }
}
