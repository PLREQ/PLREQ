//
//  CustomAnnotation.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/24.
//  Reference https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
