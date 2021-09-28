//
//  LocationAnnotation.swift
//  PickUpUser
//
//  Created by hb on 31/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationAnnotation:NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var type: UserType
    var data: Home.ViewModel?
    
    init(_ latitude:CLLocationDegrees,_ longitude:CLLocationDegrees,type:UserType, data: Home.ViewModel?){
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.type = type
        if data != nil {
            self.data = data!
        }else {
            self.data = nil
        }
        
    }
}
