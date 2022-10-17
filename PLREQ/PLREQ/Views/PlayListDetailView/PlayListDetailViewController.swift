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
        
        musicDetailTableView.dragInteractionEnabled = true
        musicDetailTableView.dragDelegate = self
        musicDetailTableView.dropDelegate = self
    }

    @IBAction func goToBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let image: UIImage = UIImage().shareWithImage(tableView: musicDetailTableView)

        let alret = UIAlertController(title: "플레이리스트가 저장됐어요!", message: "저장된 플레이리스트를 어떻게 도와드릴까요?", preferredStyle: .actionSheet)
        
        let saveImageButton = UIAlertAction(title: "저장하기", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.savedImage), nil)
        }
        
        let shareIamgeButton = UIAlertAction(title: "공유하기", style: .default) { _ in
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }

        let cancelButton = UIAlertAction(title: "취소하기", style: .cancel)
        
        alret.addAction(saveImageButton)
        alret.addAction(shareIamgeButton)
        alret.addAction(cancelButton)
        
        present(alret, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let musicData = musicList[indexPath.row]
            PLREQDataManager.shared.musicDelete(music: musicData)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            return
        }
    }
}

extension PlayListDetailViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}


extension PlayListDetailViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}

private extension PlayListDetailViewController {
    
    func setupNavigationController() {
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    @objc func savedImage(_ im: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        if let err = error {
            print(err)
            return
        }
        print("success")
    }
}
