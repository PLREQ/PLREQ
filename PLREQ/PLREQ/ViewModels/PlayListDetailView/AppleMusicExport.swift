//
//  AppleMusicExport.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/13.
//

import Foundation
import MusicKit
import StoreKit
import Combine

@available(iOS 16.0, *)
final class AppleMusicExport: MusicPlaylistAddable, Sendable {
    var id: MusicItemID = ""
    
    // 플레이리스트 추가 및 음악 목록 추가
    func addPlayList(name: String, musicList: [String]) {
        Task {
            let newPlayList = try await MusicLibrary.shared.createPlaylist(name: name, description: "PLREQ에서 생성된 플레이리스트 입니다.", authorDisplayName: "PLREQ")
            musicList.forEach() { musicTitle in
                Task {
                    var request = MusicCatalogSearchRequest.init(term: musicTitle, types: [Song.self])
                    request.includeTopResults = true
                    let reponse = try await request.response()
                    if !reponse.songs.isEmpty { // 검색한 노래가 있는지 화기인
                        try await MusicLibrary.shared.add(reponse.songs.first!, to: newPlayList)
                    }
                }
            }
        }
    }
    
    // 이름을 지정해서 해당 플레이리스트에 노래 추가
    func addSongsToPlayList(name: String, musicList: [String]) {
        Task {
            let request = MusicLibrarySearchRequest(term: name, types: [Playlist.self])
            let libraryResponse = try await request.response()
            if !libraryResponse.playlists.isEmpty { // 입력하려고하는 플레이리스트의 이름이 있는지 확인
                Task {
                    musicList.forEach() { musicTitle in
                        Task {
                            var request = MusicCatalogSearchRequest.init(term: musicTitle, types: [Song.self])
                            request.includeTopResults = true
                            let response = try await request.response()
                            if !response.songs.isEmpty { // 검색한 노래가 있는지 화기인
                                try await MusicLibrary.shared.add(response.songs.first!, to: libraryResponse.playlists[0])
                            }
                        }
                    }
                }
            } else {
                Task {
                    let newPlayList = try await MusicLibrary.shared.createPlaylist(name: name, description: "PLREQ에서 생성된 플레이리스트 입니다.", authorDisplayName: "PLREQ")
                    musicList.forEach() { musicTitle in
                        Task {
                            var request = MusicCatalogSearchRequest.init(term: musicTitle, types: [Song.self])
                            request.includeTopResults = true
                            let reponse = try await request.response()
                            if !reponse.songs.isEmpty { // 검색한 노래가 있는지 화기인
                                try await MusicLibrary.shared.add(reponse.songs.first!, to: newPlayList)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func requestMusicAuthorization()  {
        SKCloudServiceController.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                print("")
            case .restricted:
                print("")
            case .notDetermined:
                 print("")
            case .denied:
                print("")
            @unknown default:
                print("")
            }
        }
    }
    // 이름을 지정해서 해당 플레이리스트에서 노래 불러오기
    // 개발 예정
    
}

class CheckAppleMusicSubscription: ObservableObject {
    @Published var check: Bool = false
    static let shared: CheckAppleMusicSubscription = CheckAppleMusicSubscription()
    // 사용자가 애플 뮤직을 구독 중인지 확인
    func appleMusicSubscription() {
        SKCloudServiceController().requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            // 에러 발생시
            guard err == nil else { return }
            // 사용자가 애플 뮤직을 구독 중이라면
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) { self.check = true }
            // 사용자가 애플 뮤직을 구독 중이지 않다면
            if capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) { self.check = false }
        }
    }
}
