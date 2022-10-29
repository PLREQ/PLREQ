//
//  CustomAnnotation.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/29.
//

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
