//
//  PLREQDataManager.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/11.
//

import Foundation
import UIKit
import CoreData

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
    
    // 플레이리스트 불러오기
    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: playListModelName)
        
        let sort = NSSortDescriptor(key: "day", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        var result = [NSManagedObject]()
        
        do {
            result = try! context.fetch(fetchRequest)
        } catch {
            print("fetch fail")
        }
        
        return result
    }
    
    // 플레이리스트 저장
    func save(title: String, location: String, day: Date, latitude: Double, longtitude: Double, musics: [Music]) -> Bool {
        let playListObject = NSEntityDescription.insertNewObject(forEntityName: playListModelName, into: context)
        playListObject.setValue(title, forKey: "title")
        playListObject.setValue(day, forKey: "day")
        playListObject.setValue(location, forKey: "location")
        playListObject.setValue(latitude, forKey: "latitude")
        playListObject.setValue(longtitude, forKey: "longtitude")
        for music in musics {
            let musicObject = NSEntityDescription.insertNewObject(forEntityName: MusicModelName, into: context) as! MusicDB
            musicObject.title = music.title
            musicObject.artist = music.artist
            DispatchQueue.global().async {  
                if let data = try? Data(contentsOf: music.musicImageURL) {
                    if let image = UIImage(data: data) {
                        musicObject.musicImage = image.jpegData(compressionQuality: 1.0)
                    }
                }
                (playListObject as! PlayListDB).addToMusic(musicObject)
            }
        }
        return saveContext()
    }
    
    // 플레이리스트 삭제
    func delete(playListObject: NSManagedObject) -> Bool {
        context.delete(playListObject)
        
        return saveContext()
    }
    
    // 플레이리스트의 제목 변경
    func updateTitle(playListObject: NSManagedObject, title: String) -> Bool {
        playListObject.setValue(title, forKey: "title")
        
        return saveContext()
    }
    
    // 플레이리스트의 음악 목록들을 불러오기
    func musicsFetch(playList: PlayListDB) -> [MusicDB] {
        return playList.music?.array as! [MusicDB]
    }
    
    // 음악을 삭제
    func musicDelete(music: NSManagedObject) -> Bool {
        context.delete(music)
        
        return saveContext()
    }
    
    // 플레이리스트에 곡들을 추가
    func addToPlayList(playListObject: NSManagedObject, musics: [MusicData]) -> Bool {
        for music in musics {
            let musicObject = NSEntityDescription.insertNewObject(forEntityName: MusicModelName, into: context) as! MusicDB
            musicObject.title = music.title
            musicObject.artist = music.artist
            musicObject.musicImage = music.musicImage
            
            (playListObject as! PlayListDB).addToMusic(musicObject)
        }
        
        return saveContext()
    }
    
    // 바뀐 음악의 순서를 저장
    func musicChangeOrder(playListObject: [NSManagedObject], musics: [MusicData]) -> Bool {
        for i in 0..<playListObject.count {
                playListObject[i].setValue(musics[i].title, forKey: "title")
                playListObject[i].setValue(musics[i].artist, forKey: "artist")
                playListObject[i].setValue(musics[i].musicImage, forKey: "musicImage")
        }
        
        return saveContext()
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
