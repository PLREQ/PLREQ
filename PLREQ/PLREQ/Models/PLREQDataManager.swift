//
//  PLREQDataManager.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/11.
//

import Foundation
import UIKit
import CoreData

struct Music {
    var title: String
    var artist: String
    var musicImageURL: URL
}

class PLREQDataManager {
    static let shared: PLREQDataManager = PLREQDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PLREQ")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let playListModelName: String = "PlayList"
    let MusicModelName: String = "Music"
    
    // 불러오기
    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: playListModelName)
        
        let sort = NSSortDescriptor(key: "day", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    func save(title: String, artist: String, location: String, latitude: Float, longtitude: Float, firstImageURL: URL, secondImageURL: URL, thirdImageURL: URL, fourthImageURL: URL, musics: [Music]) -> Bool {
        let playListObject = NSEntityDescription.insertNewObject(forEntityName: playListModelName, into: context)
        playListObject.setValue(title, forKey: "location")
        playListObject.setValue(artist, forKey: "artist")
        playListObject.setValue(Date(), forKey: "day")
        playListObject.setValue(location, forKey: "location")
        playListObject.setValue(latitude, forKey: "latitude")
        playListObject.setValue(longtitude, forKey: "longtitude")
        playListObject.setValue(firstImageURL, forKey: "firstImageURL")
        playListObject.setValue(secondImageURL, forKey: "secondImageURL")
        playListObject.setValue(thirdImageURL, forKey: "thirdImageURL")
        playListObject.setValue(fourthImageURL, forKey: "fourthImageURL")
        
        for music in musics {
            var musicObject = NSEntityDescription.insertNewObject(forEntityName: MusicModelName, into: context) as! MusicDB
            musicObject.title = music.title
            musicObject.artist = music.artist
            musicObject.musicImageURL = music.musicImageURL
            
            (playListObject as! PlayListDB).addToMusic(musicObject)
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func delete(playListObject: NSManagedObject) -> Bool {
        context.delete(playListObject)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
