//
//  PlayList+CoreDataProperties.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/08.
//
//

import Foundation
import CoreData

extension PlayList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayList> {
        return NSFetchRequest<PlayList>(entityName: "PlayList")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var day: Date?
    @NSManaged public var location: String?
    @NSManaged public var firstImageURL: URL?
    @NSManaged public var secondImageURL: URL?
    @NSManaged public var thirdImageURL: URL?
    @NSManaged public var fourthImageURL: URL?
    @NSManaged public var latitude: Float
    @NSManaged public var longtitude: Float
    @NSManaged public var relationship: Music?

}

extension PlayList: Identifiable {

}
