//
//  StaticPageRouter.swift
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

protocol StaticPageRoutingLogic {
    
}

protocol StaticPageDataPassing {
    var dataStore: StaticPageDataStore? { get set}
}

class StaticPageRouter: NSObject, StaticPageRoutingLogic, StaticPageDataPassing {
    weak var viewController: StaticPageViewController?
    var dataStore: StaticPageDataStore?
}
