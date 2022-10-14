//
//  PlayListDetailViewController.swift
//  PLREQ
//
//  Created by 이성노 on 2022/09/27.
//

import UIKit

final class PlayListDetailViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var shareButtonTapped: UIButton!
    @IBOutlet weak var musicDetailTableView: UITableView!
    
    var playList: PlayListDB!
    var musicList: [MusicDB]! {
        return playList.music?.array as? [MusicDB]
    }
    
    var navigationTitleText: String! {
        return "\(playList.dataToString(forKey: "title"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        navigationTitle.title = navigationTitleText
        
        musicDetailTableView.dataSource = self
        
        shareButtonTapped.layer.cornerRadius = shareButtonTapped.frame.height / 2
    }

    @IBAction func goToBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        print("Is it sellected?")
    }
}

extension PlayListDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playListDetailCell", for: indexPath) as? PlayListDetailCell
        
        let musicData = musicList[indexPath.row]
        cell?.musicImage.load(url: musicData.dataToURL(forKey: "musicImageURL"))
        cell?.musicImage.layer.cornerRadius = 6

        cell?.musicTitle.text = musicData.dataToString(forKey: "title")
        cell?.musicArtist.text = musicData.dataToString(forKey: "artist")
        
        return cell ?? UITableViewCell()
    }
}

private extension PlayListDetailViewController {
    
    func setupNavigationController() {
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
}
