//
//  API.swift
//  My Home Hub
//
//  Created by hb on 28/09/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation

public protocol API {
    static func createTokenWebserviceRequest(completed: @escaping (_ success: Bool, _ error: NetworkError?) -> Void)
}

//public class GlobelAPI: API {
//    public static func createTokenWebserviceRequest(completed: @escaping (_ success: Bool, _ error: NetworkError?) -> Void) {
//        NetworkService.tokenCreationDataRequest(with: WSTokenRouter.createToken) { (response, error) in
//            guard let data = response, error == nil else {
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let detail = try decoder.decode(WSResponse<WSTokenModel>.self, from: data) as WSResponse<WSTokenModel>
//                if let resp = detail.dictData, let success = detail.setting?.isSuccess, success {
//                    MyHomeHubSessionHandler.shared.setWSToken(token: resp.webserviceToken ?? "")
//                    completed(true, nil)
//                } else {
//                    print(detail.setting?.message ?? "ERROR")
//                    completed(false, .requestError(errorMessage: detail.setting?.message ?? "ERROR"))
//                }
//            } catch let err {
//                completed(false, .requestError(errorMessage: err.localizedDescription))
//            }
//        }
//    }
//}
