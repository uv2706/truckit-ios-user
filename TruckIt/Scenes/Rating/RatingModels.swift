//
//  RatingModels.swift
//  TruckIt
//
//  Created by hb on 28/05/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Rating
{
  // MARK: Use cases
  
  struct Request {
      var toId: String
      var rating: String
      var review: String
      var pickUpId: String
  }
  
  class ViewModel: WSResponseData {
      public override func encode(to encoder: Encoder) throws {
          try super.encode(to: encoder)
      }
      
      required public init(from decoder: Decoder) throws {
          try super.init(from: decoder)
      }
  }
}
