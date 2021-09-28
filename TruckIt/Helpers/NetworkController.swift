//
//  NetworkController.swift
//  GoogleCivicsAPI
//
//  Created by hb on 08/04/19.
//  Copyright © 2019 hb. All rights reserved.
//


import Foundation
class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequestForURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, header: [String: String]? = nil, body: NSData? = nil, completion: ((_ data: NSData?, _ error: NSError?) ->Void)?) {
        var request: NSMutableURLRequest?
        if urlParameters != nil {
            let requestUrl = urlFromParameters(url: url, urlParameters: urlParameters)
            request = NSMutableURLRequest(url: requestUrl as URL)
        } else {
            request = NSMutableURLRequest(url: url as URL)
        }
        request?.httpMethod = httpMethod.rawValue
        request?.httpBody = body as? Data
        request?.allHTTPHeaderFields = header
        guard let newRequest = request else {
            if let completion = completion {
                completion(nil, nil)
            }
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: newRequest as URLRequest) { (data, response, error) in
            if let completion = completion {
                guard data != nil else {
                    completion(nil,error as! NSError)
                    return
                }
                completion(data! as NSData, error as NSError?)
            }
        }
        dataTask.resume()
        
    }
    
    static func urlFromParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(url: url as URL, resolvingAgainstBaseURL: true)
        
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)}) as! [URLQueryItem]
        
        if let url = components?.url {
            return url as NSURL
        } else {
            fatalError("URL optional is nil")
        }
    }
    
    
}
