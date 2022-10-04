//
//  MatchViewController.swift
//  PLREQ
//
//  Created by 이영준 on 2022/09/27.
//

import UIKit
import ShazamKit

struct Music {
    var title: String
    var artist: String
    var musicImageURL: URL
}

class MatchViewController: UIViewController {

    //MARK: Variabales
    var recordedMusicList = [Music]()
    var recordedMusic = Music(title: "", artist: "", musicImageURL: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/46/e3/8c/46e38c01-05a5-5787-af4b-593dde5ba586/8809550047556.jpg/800x800bb.jpg")!)
//    var recordedMusic: Music?
    var viewModel: MatchViewModel?
    var isListening: Bool = false
    
    //MARK: IBOutlet Variable
    @IBOutlet weak var playListButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var matchMusicCollectionView: UICollectionView!
    
    //MARK: IBOutlet Function
    @IBAction func tapRecordButton(_ sender: UIButton) {
        self.isListening.toggle()
        if self.isListening {
            do {
                print("👀")
                try self.viewModel?.songSearch()
                
            } catch {
                print("error")
            }
        } else {
            print("isListening : \(self.isListening)")
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
    
    private func songMatched(item: SHMatchedMediaItem?, error: Error?) {
        print("❤️")
        if error != nil {
            self.viewModel?.status = false
            print("🔥")
        } else {
            print("😇")
            self.viewModel?.status = true
            
            self.viewModel?.title = item?.title
            self.viewModel?.artist = item?.artist
            self.viewModel?.musicImageURL = item?.artworkURL
            print(viewModel?.title)
            viewDraw()
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

extension MatchViewController:  UICollectionViewDataSource {
    
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
