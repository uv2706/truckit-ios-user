//
//  StaticPageAPIRouter.swift
//  Udecide
//
//  Created by hb on 15/04/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum StaticPageAPIRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    case staticPage(request: StaticPage.Request)
    case reportAProblem(request: ReportAProblem.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .staticPage:
            return "/static_pages"
        case .reportAProblem:
            return "/post_a_feedback"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .staticPage(let request):
            return [
                "page_code": request.pageCode,
            ]
        case .reportAProblem(let request):
            return [
         //       "user_id": TruckItSessionHandler.shared.userId,
//                "user_access_token": TruckItSessionHandler.shared.userAuthToken,
                "feedback": request.problem
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
        return nil
    }
}
