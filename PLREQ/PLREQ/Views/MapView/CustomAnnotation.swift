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
    
    let playList: PlayListDB
    var musicImage: [UIImage] = []
    
    init(coordinate: CLLocationCoordinate2D, playListDB: PlayListDB) {
        self.coordinate = coordinate
        self.playList = playListDB
        super.init()
        configuration(playListDB: playListDB)
    }

    private func configuration(playListDB: PlayListDB) {
        let musicsData = playListDB.music?.array as? [MusicDB]
        for i in 0..<4 {
            if i < musicsData!.count {
                musicImage.append(UIImage(data: musicsData![i].dataToData(forKey: "musicImage"))!)
            } else {
                musicImage.append(UIImage(named: "emptyImage")!)
            }
        }
    }
}
