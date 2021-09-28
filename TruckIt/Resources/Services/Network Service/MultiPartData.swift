//
//  MultiPartData.swift
//  My Home Hub
//
//  Created by hb on 03/10/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
import UIKit

public struct MultiPartData {
    var fileName: String!
    var data: Data!
    var paramKey: String!
    var mimeType: String!
    var urlString: URL?
    var fileKey: String?
}
