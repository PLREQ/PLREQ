//
//  MusicDB+CoreDataProperties.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/11.
//
//

import Foundation
import CoreData

extension MusicDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicDB> {
        return NSFetchRequest<MusicDB>(entityName: "Music")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var musicImage: Data?
    
    @NSManaged public var playlist: PlayListDB?

}

extension MusicDB : Identifiable {

}
