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
    
    func screenshot() -> UIImage{
        var image = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(self.musicDetailTableView.contentSize, false, UIScreen.main.scale)
        
        // 초기값을 저장합니다.
        let savedContentOffset = self.musicDetailTableView.contentOffset
        let savedFrame = self.musicDetailTableView.frame
        let savedBackgroundColor = self.musicDetailTableView.backgroundColor
        
        // offset을 좌표(0, 0)으로 설정합니다.
        self.musicDetailTableView.contentOffset = CGPoint(x: 0, y: 0)
        
        // frame을 content 크기로 설정합니다.
        self.musicDetailTableView.frame = CGRect(x: 0, y: 0, width: self.musicDetailTableView.contentSize.width, height: self.musicDetailTableView.contentSize.height)
        
        // ScrollView 크기로 tempView 생성
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.musicDetailTableView.contentSize.width, height: self.musicDetailTableView.contentSize.height))
        
        // Superview를 저장합니다.
        let tempSuperView = self.musicDetailTableView.superview
        
        // Constraints를 저장합니다.
        guard let superView = tempSuperView else {
            return UIImage()
        }
        
        // tableView에서 이전의 constraints를 받아옵니다.
        var previousConstraints: [NSLayoutConstraint] = []
        for constraint in superView.constraints {
            if constraint.firstItem as? NSObject == self.musicDetailTableView || constraint.secondItem as? NSObject == self.musicDetailTableView {
                previousConstraints.append(constraint)
            }
        }
        
        // old superView에서 scrollView를 제거합니다.
        self.musicDetailTableView.removeFromSuperview()
        
        // 그러곤 tempView에 추가해줍니다.
        tempView.addSubview(self.musicDetailTableView)
        
        // view를 render해줍니다.
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // 이미지를 받아옵니다.
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self.musicDetailTableView)
        
        // oldConstraints를 활성화합니다.
        NSLayoutConstraint.activate(previousConstraints)
        
        // 가공된 값을 넣어줍니다.
        self.musicDetailTableView.contentOffset = savedContentOffset
        self.musicDetailTableView.frame = savedFrame
        self.musicDetailTableView.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    @objc func savedImage(_ im: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        if let err = error {
            print(err)
            return
        }
        print("success")
    }
}
