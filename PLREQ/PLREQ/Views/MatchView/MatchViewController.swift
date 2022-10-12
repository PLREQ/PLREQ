//
//  MatchViewController.swift
//  PLREQ
//
//  Created by 이영준 on 2022/09/27.
//

import UIKit
import ShazamKit

class MatchViewController: UIViewController {

    //MARK: Variabales
    var recordedMusicList = [Music]()
    // 임시 Image URL 추가
    var recordedMusic = Music(title: "", artist: "", musicImageURL: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/46/e3/8c/46e38c01-05a5-5787-af4b-593dde5ba586/8809550047556.jpg/800x800bb.jpg")!)
    var viewModel: MatchViewModel?
    var isListening: Bool = false
    var timer: Timer?
    
    //MARK: IBOutlet Variable
    @IBOutlet weak var playListButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var matchMusicCollectionView: UICollectionView!
    
    //MARK: IBOutlet Function
    @IBAction func tapRecordButton(_ sender: UIButton) {
        self.isListening.toggle()
        if self.isListening {
            timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: true)
        } else {
            print("----- Not Listening -----")
        }
    }
    
    @IBAction func tapPlayListButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "PlayListView", bundle: nil)
        guard let playListViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListView") as? PlayListViewController else { return }
        self.navigationController?.pushViewController(playListViewController, animated: true)
    }
    
    @objc func catchMusic() {
        do {
            try self.viewModel?.songSearch()
        } catch {
            print("error")
        }
    }
    
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewModel = MatchViewModel(matchHandler: songMatched)
    }
    
    //MARK: Style Function
    private func styleFunction() {
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        self.matchMusicCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.matchMusicCollectionView.backgroundColor = UIColor.white
        self.matchMusicCollectionView.delegate = self
        self.matchMusicCollectionView.dataSource = self
    }
    
    //MARK: Shazam Function
    private func songMatched(item: SHMatchedMediaItem?, error: Error?) {
        if error != nil {
            self.viewModel?.status = false
        } else {
            self.viewModel?.status = true
            
            // 동일한 타이틀, 아티스트의 음악이 이미 배열에 있는 경우 추가하지 않고 함수 종료
            for music in recordedMusicList {
                if music.title == item?.title && music.artist == item?.artist {
                    print("🥹")
                    return
                }
            }
            print("🔥")
            self.viewModel?.title = item?.title
            self.viewModel?.artist = item?.artist
            self.viewModel?.musicImageURL = item?.artworkURL
            self.viewDraw()
        }
    }
    
    private func viewDraw() {
        self.recordedMusic.title = self.viewModel?.title ?? ""
        self.recordedMusic.artist = self.viewModel?.artist ?? ""
        self.recordedMusic.musicImageURL = self.viewModel?.musicImageURL ?? URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/46/e3/8c/46e38c01-05a5-5787-af4b-593dde5ba586/8809550047556.jpg/800x800bb.jpg")!
        
        self.recordedMusicList.append(self.recordedMusic)
        self.matchMusicCollectionView.reloadData()
    }
}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordedMusicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.matchMusicCollectionView.dequeueReusableCell(withReuseIdentifier: "MatchMusicCell", for: indexPath) as? MatchMusicCell else { return UICollectionViewCell() }
        let music = self.recordedMusicList[indexPath.row]
        cell.musicTitle.text = music.title
        cell.musicArtist.text = music.artist
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: music.musicImageURL)
            DispatchQueue.main.async {
                cell.musicImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
}

extension MatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}
