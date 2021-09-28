//
//  MessageRouter.swift
//  PickUpDriver
//
//  Created by hb on 17/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MessageRoutingLogic {
    
}

protocol MessageDataPassing {
    var dataStore: MessageDataStore? { get set }
}

class MessageRouter: NSObject, MessageRoutingLogic, MessageDataPassing {
    weak var viewController: MessageViewController?
    var dataStore: MessageDataStore?
    
}