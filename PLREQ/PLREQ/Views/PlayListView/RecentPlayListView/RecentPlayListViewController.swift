//
//  RecentPlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit
import CoreData

class RecentPlayListViewController: UIViewController {
    
    @IBOutlet weak var recentPlayListCollectionView: UICollectionView!
    
    var playListList: [NSManagedObject] = []
    let playListCollectionViewCellNib: UINib = UINib(nibName: "PlayListCollectionViewCell", bundle: nil)
    let playListCollectionViewCell: String = "PlayListCollectionViewCell"
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshReloadCollectView), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentPlayListCollectionView.refreshControl = refreshControl
        collectionViewLink()
        registerNib()
        setAutoLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .viewReload, object: nil)
    }
    
    @objc func refreshReloadCollectView() {
        self.playListList = PLREQDataManager.shared.fetch()
        self.recentPlayListCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func reloadView(_ noti: Notification) {
        self.playListList = PLREQDataManager.shared.fetch()
        self.recentPlayListCollectionView.reloadData()
    }

    private func collectionViewLink() {
        self.recentPlayListCollectionView.delegate = self
        self.recentPlayListCollectionView.dataSource = self
    }
    
    private func registerNib() {
        self.recentPlayListCollectionView.register(playListCollectionViewCellNib, forCellWithReuseIdentifier: playListCollectionViewCell)
    }
    
    private func setAutoLayout() {
        self.recentPlayListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.recentPlayListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0 ).isActive = true
        self.recentPlayListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.recentPlayListCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width / 20).isActive = true
        self.recentPlayListCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(self.view.frame.width / 20)).isActive = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RecentPlayListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCollectionViewCell, for: indexPath) as? PlayListCollectionViewCell else { return UICollectionViewCell()}
        
        let playListData = playListList[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath.row
        let musicsData = (playListData as! PlayListDB).music?.array as? [MusicDB]
        for i in 0..<4 {
            if i < musicsData!.count {
                cell.PlayListImageArr[i].load(data: musicsData![i].dataToData(forKey: "musicImage"))
            } else {
                cell.PlayListImageArr[i].image = UIImage()
            }
        }
        
        cell.playListName.setLable(text: playListData.dataToString(forKey: "title"), fontSize: 14)
        
        cell.playListDay.setLable(text: Date().toYMDString(date: playListData.dataToDate(forKey: "day")), fontSize: 12)
        
        cell.layer.cornerRadius = self.view.frame.width / 2.3375 / 16
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "PlayListDetailView", bundle: nil)
        guard let playListDetailViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListDetailView") as? PlayListDetailViewController else { return }
        playListDetailViewController.playList = (playListList[indexPath.row] as! PlayListDB)
        self.navigationController?.pushViewController(playListDetailViewController, animated: true)
    }
}

extension RecentPlayListViewController: UICollectionViewDelegateFlowLayout {
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    
    // 윗 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 셀의 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2.3375
        let size = CGSize(width: width, height: width * 25 / 16 )
        //        let size = CGSize(width: 160, height: 250)
        return size
    }
}

extension RecentPlayListViewController: collectionViewCelEditButtonlClicked {
    func buttonClicked(indexPath: Int) {
        let alret = UIAlertController(title: playListList[indexPath].dataToString(forKey: "title"), message: "알림창 내용", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "플레이리스트 삭제", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "\(self.playListList[indexPath].dataToString(forKey: "title"))를 정말 삭제하시겠어요?", message: "삭제하면 되돌릴 수 없어요!", preferredStyle: .alert)
            let deleteCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deletePlayList = UIAlertAction(title: "플레이리스트 삭제", style: .destructive) { _ in
                _ = PLREQDataManager.shared.delete(playListObject: self.playListList[indexPath])
                NotificationCenter.default.post(name: .viewReload, object: nil)
            }
            deleteAlert.addAction(deleteCancel)
            deleteAlert.addAction(deletePlayList)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        let apple = UIAlertAction(title: "애플뮤직으로 내보내기", style: .default) { _ in
            if #available(iOS 16.0, *) {
                AppleMusicExport().requestMusicAuthorization()
                let appleAlert = UIAlertController(title: "정말 내보내시겠어요?", message: "'\(self.playListList[indexPath].dataToString(forKey: "title"))'으로 저장됩니다.", preferredStyle: .alert)
                let appleCancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                let addPlayList = UIAlertAction(title: "플레이리스트 내보내기", style: .default) { _ in
                    CheckAppleMusicSubscription.shared.appleMusicSubscription()
                    let musicLists = (self.playListList[indexPath] as! PlayListDB).music?.array as? [MusicDB]
                    var musicListsTitle: [String] = []
                    for i in 0..<musicLists!.count {
                        musicListsTitle.append("")
                        musicListsTitle[i] = musicListsTitle[i] + musicLists![i].dataToString(forKey: "artist") + " " + musicLists![i].dataToString(forKey: "title")
                    }
                    AppleMusicExport().addPlayList(name: self.playListList[indexPath].dataToString(forKey: "title"), musicList: musicListsTitle)
                }
                appleAlert.addAction(addPlayList)
                appleAlert.addAction(appleCancel)
                self.present(appleAlert, animated: true, completion: nil)
            } else {
                let appleAlert = UIAlertController(title: "애플 뮤직 관련 기능을 사용하실려면 iOS 16버전 이상의 버전이 필요합니다.", message: "사용하시려면 iOS 버전을 확인해주세요.", preferredStyle: .alert)
                let appleCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                appleAlert.addAction(appleCancel)
                self.present(appleAlert, animated: true, completion: nil)
            }
        }
        
        let appleName = UIAlertAction(title: "애플뮤직 특정 플레이리스트에 추가하기", style: .default) { _ in
            let appleNameAlert = UIAlertController(title: "이름을 입력해주세요.\n(일치하는 플레이리스트가 없다면 입력한 이름으로 저장됩니다.)", message: nil, preferredStyle: .alert)
            let registerButton = UIAlertAction(title: "저장", style: .default, handler: { _ in
                CheckAppleMusicSubscription.shared.appleMusicSubscription()
                if #available(iOS 16.0, *) {
                    AppleMusicExport().requestMusicAuthorization()
                    guard var playlistTitle = appleNameAlert.textFields?[0].text else { return }
                    if((playlistTitle == "")) { playlistTitle = self.playListList[indexPath].dataToString(forKey: "title") }
                    let musicLists = (self.playListList[indexPath] as! PlayListDB).music?.array as? [MusicDB]
                    var musicListsTitle: [String] = []
                    for i in 0..<musicLists!.count {
                        musicListsTitle.append("")
                        musicListsTitle[i] = musicListsTitle[i] + musicLists![i].dataToString(forKey: "artist") + " " + musicLists![i].dataToString(forKey: "title")
                    }
                    AppleMusicExport().addSongsToPlayList(name: playlistTitle, musicList: musicListsTitle)
                    appleNameAlert.dismiss(animated: true)
                    CheckAppleMusicSubscription.shared.appleMusicSubscription()
                } else {
                    let appleAlert = UIAlertController(title: "애플 뮤직 관련 기능을 사용하실려면 iOS 16버전 이상의 버전이 필요합니다.", message: "사용하시려면 iOS 버전을 확인해주세요.", preferredStyle: .alert)
                    let appleCancel = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    appleAlert.addAction(appleCancel)
                    self.present(appleAlert, animated: true, completion: nil)
                }
            })
            let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: { _ in
                appleNameAlert.dismiss(animated: true)
            })
            
            appleNameAlert.addAction(cancelButton)
            appleNameAlert.addAction(registerButton)
            appleNameAlert.addTextField(configurationHandler: { textField in
                textField.placeholder = self.playListList[indexPath].dataToString(forKey: "title")
            })
            
            self.present(appleNameAlert, animated: true)
        }
        
        let changeTitle = UIAlertAction(title: "플레이리스트 이름 변경하기", style: .default) { _ in
            let changeAlert = UIAlertController(title: "이름을 입력해주세요.", message: nil, preferredStyle: .alert)
            let registerButton = UIAlertAction(title: "저장", style: .default, handler: { _ in
                guard var title = changeAlert.textFields?[0].text else { return }
                if(title == "") { title = "PLREQ" }
                _ = PLREQDataManager.shared.updateTitle(playListObject: self.playListList[indexPath], title: title)
                NotificationCenter.default.post(name: .viewReload, object: nil)
            })
            let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: { _ in
                changeAlert.dismiss(animated: true)
            })
            
            changeAlert.addAction(cancelButton)
            changeAlert.addAction(registerButton)
            changeAlert.addTextField(configurationHandler: { textField in
                textField.placeholder = "PLREQ"
            })
            
            self.present(changeAlert, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alret.addAction(cancel)
        alret.addAction(changeTitle)
        alret.addAction(apple)
        alret.addAction(appleName)
        alret.addAction(delete)
        present(alret, animated: true, completion: nil)
    }
}
