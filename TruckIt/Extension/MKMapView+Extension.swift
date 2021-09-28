//
//  File.swift
//  TapATrade
//
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation
import UIKit
import MapKit
@available(iOS 10.0, *)

extension MKMapView
{
    func zoomMapaFitAnnotations() {
        
        var zoomRect = MKMapRect.null
        for annotation in self.annotations {
            
            let annotationPoint = MKMapPoint(annotation.coordinate)
            
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            
            if zoomRect.isNull{
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
            
            
        }
        self.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        
    }
}


