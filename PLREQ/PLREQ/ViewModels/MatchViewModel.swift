//
//  MatchViewModel.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import ShazamKit
import AVFAudio
// AVFoundation에서 오디오 부분만 사용하기에 AVFAudio를 import

class MatchViewModel: NSObject {
    var session: SHSession?
    let audioEngine = AVAudioEngine()
    var matchHandler: ((SHMatchedMediaItem?, Error?) -> Void)?
    var lastMatch: SHMatchedMediaItem?
    
    // 음악 검색 결과를 담을 변수 선언
    var title: String?
    var artist: String?
    var musicImageURL: URL?
    // 노래를 검색하였을 때 검색에 실패하면 false, 성공하면 true
    var status: Bool = false
    
    init(matchHandler handler: ((SHMatchedMediaItem?, Error?) -> Void)?) {
        matchHandler = handler
    }
    
    func songSearch(catalog: SHCustomCatalog? = nil) throws {
        if let catalog = catalog {
            session = SHSession(catalog: catalog)
        } else {
            session = SHSession()
        }
        
        session?.delegate = self
        
        let audioFormat = AVAudioFormat(
            standardFormatWithSampleRate: audioEngine.inputNode.outputFormat(forBus: 0).sampleRate,
            channels: 1)
        audioEngine.inputNode.installTap(
            onBus: 0,
            bufferSize: 2048,
            format: audioFormat
        ) { [weak session] buffer, audioTime in
            session?.matchStreamingBuffer(buffer, at: audioTime)
        }
        
        try AVAudioSession.sharedInstance().setCategory(.record)
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] success in
            guard
                success,
                let self = self
            else { return }
            try? self.audioEngine.start()
        }
    }
    
    func stopListening() {
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

extension MatchViewModel: SHSessionDelegate {
    public func session(_ session: SHSession, didFind match: SHMatch) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let handler = self.matchHandler {
                handler(match.mediaItems.first, nil)
                self.stopListening()
            }
        }
    }
    
    public func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let handler = self.matchHandler {
                handler(nil, error)
                self.stopListening()
            }
        }
    }
}
