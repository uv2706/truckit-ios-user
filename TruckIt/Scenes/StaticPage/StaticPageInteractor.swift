//
//  StaticPageInteractor.swift
//  Udecide
//
//  Created by hb on 15/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol StaticPageBusinessLogic {
    func staticPage(request: StaticPage.Request)
}

protocol StaticPageDataStore {
    var pageCode: String { get set }
}

class StaticPageInteractor: StaticPageBusinessLogic, StaticPageDataStore {
    var pageCode: String = ""
    
    var presenter: StaticPagePresentationLogic?
    var worker: StaticPageWorker?
    
    func staticPage(request: StaticPage.Request) {
        worker = StaticPageWorker()
        worker?.staticPage(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentStaticPage(response: response, message: message ?? "", success: success ?? "0")
        })
    }
}
