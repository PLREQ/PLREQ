//
//  Music+CoreDataProperties.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/08.
//
//

import Foundation
import CoreData

extension Music {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Music> {
        return NSFetchRequest<Music>(entityName: "Music")
    }

    @NSManaged public var artist: String?
    @NSManaged public var musicImageURL: URL?
    @NSManaged public var title: String?

}

extension Music: Identifiable {

}
