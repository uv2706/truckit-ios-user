//
//  GiveRatingInteractor.swift
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

protocol GiveRatingBusinessLogic {
    func giveRating(req: GiveRating.Request)
}

protocol GiveRatingDataStore {
    
}

class GiveRatingInteractor: GiveRatingBusinessLogic, GiveRatingDataStore {
    var presenter: GiveRatingPresentationLogic?
    var worker: GiveRatingWorker?

    func giveRating(req: GiveRating.Request) {
        worker = GiveRatingWorker()
        worker?.giveRating(request: req, completionHandler: { (message, success) in
            self.presenter?.presentGiveRating(message: message ?? "", success: success ?? "0")
        })
    }
}