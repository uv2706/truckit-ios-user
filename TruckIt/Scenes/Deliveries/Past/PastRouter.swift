//
//  PastRouter.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PastRoutingLogic {
    
}

protocol PastDataPassing {
    var dataStore: PastDataStore? { get set }
}

class PastRouter: NSObject, PastRoutingLogic, PastDataPassing {
    weak var viewController: PastViewController?
    var dataStore: PastDataStore?
}
