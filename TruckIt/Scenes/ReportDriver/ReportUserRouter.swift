//
//  ReportUserRouter.swift
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

protocol ReportUserRoutingLogic {
    
}

protocol ReportUserDataPassing {
    var dataStore: ReportUserDataStore? { get set }
}

class ReportUserRouter: NSObject, ReportUserRoutingLogic, ReportUserDataPassing {
    weak var viewController: ReportUserViewController?
    var dataStore: ReportUserDataStore?
    
    
}