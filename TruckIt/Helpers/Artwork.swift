//
//  Artwork.swift
//  PickUpUser
//
//  Created by hb on 31/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}


