//
//  PlayListDetailViewController.swift
//  PLREQ
//
//  Created by 이성노 on 2022/09/27.
//

import UIKit

final class PlayListDetailViewController: UIViewController {
    
    @IBOutlet weak var shareButtonTapped: UIButton!
    @IBOutlet weak var musicDetailTableView: UITableView!
    
    var playList: PlayListDB!
    var musicList: [MusicDB]! {
        return playList.music?.array as? [MusicDB]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicDetailTableView.delegate = self
        musicDetailTableView.dataSource = self
        
        shareButtonTapped.layer.cornerRadius = shareButtonTapped.frame.height / 2
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        print("되나?")
    }
}

extension PlayListDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListDetailCell", for: indexPath) as? PlayListDetailCell
        
        let musicData = musicList[indexPath.row]
        cell?.musicImage.load(url: musicData.dataToURL(forKey: "musicImageURL"))
        cell?.musicImage.layer.cornerRadius = 6
//        view.layer.cornerRadius = Constant.thumbnailSize / 2.0

        cell?.musicTitle.text = musicData.dataToString(forKey: "title")
        cell?.musicArtist.text = musicData.dataToString(forKey: "artist")
        
        return cell ?? UITableViewCell()
    }
}
