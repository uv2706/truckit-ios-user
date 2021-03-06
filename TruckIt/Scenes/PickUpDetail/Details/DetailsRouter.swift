//
//  DetailsRouter.swift
//  PickUpUser
//
//  Created by hb on 17/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailsRoutingLogic {
    
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore? { get set }
}

class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {
    weak var viewController: DetailsViewController?
    var dataStore: DetailsDataStore?
}
