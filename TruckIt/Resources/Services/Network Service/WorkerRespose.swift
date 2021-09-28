//
//  WorkerRespose.swift
//  My Home Hub
//
//  Created by hb on 28/09/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation

enum WorkerResponse<T> {
    case success(T)
    case failure(Error)
}
