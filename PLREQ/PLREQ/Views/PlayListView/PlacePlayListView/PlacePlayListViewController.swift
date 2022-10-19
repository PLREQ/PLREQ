//
//  PlacePlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit
import CoreData

class PlacePlayListViewController: UIViewController {
    
    @IBOutlet weak var placePlayListTableView: UITableView!
    let placePlayListTableViewCellNib: UINib = UINib(nibName: "PlacePlayListTableViewCell", bundle: nil)
    let placePlayListTableViewCell: String = "PlacePlayListTableViewCell"
    
    var playListList: [NSManagedObject] = []
    var placeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableViewLink()
        setAutoLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .viewReload, object: nil)
        // Do any additional setup after loading the view.
    }

    @objc func reloadView(_ noti: Notification) {
        self.playListList = PLREQDataManager.shared.fetch()
        self.placeList.removeAll()
        self.placePlayListTableView.reloadData()
    }
    
    private func registerNib() {
        placePlayListTableView.register(placePlayListTableViewCellNib, forCellReuseIdentifier: placePlayListTableViewCell)
    }
    
    private func tableViewLink() {
        self.placePlayListTableView.delegate = self
        self.placePlayListTableView.dataSource = self
    }
    
    private func setAutoLayout() {
        self.placePlayListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.placePlayListTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0 ).isActive = true
        self.placePlayListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.placePlayListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width / 20).isActive = true
        self.placePlayListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
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

extension PlacePlayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 플레이리스트 목록에서 같은 지역을 가진 경우에는 하나의 테이블 영역에 모두 들어가기에 지역의 갯수를 체크하여 지역의 갯수에 맞추어 테이블 뷰 갯수를 반환
        for i in 0..<playListList.count {
            let playListData = playListList[i]
            var check: Bool = false
            if placeList.isEmpty {
                placeList.append(playListData.dataToString(forKey: "location"))
            } else {
                for j in 0..<placeList.count {
                    if playListData.dataToString(forKey: "location") == self.placeList[j] {
                        check.toggle()
                        break
                    }
                }
                if !check {
                    placeList.append(playListData.dataToString(forKey: "location"))
                }
            }
        }
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: placePlayListTableViewCell, for: indexPath) as? PlacePlayListTableViewCell else { return UITableViewCell() }
        cell.playListList.removeAll()
        cell.delegate = self
        cell.editDelegate = self
        cell.placeName.setLable(text: placeList[indexPath.row], fontSize: 18)
        // 테이블뷰의 이름과 플레이리스트안의 지역 이름을 비교하여 테이블뷰 안의 컬렉션 뷰 셀의 갯수를 미리 지정
        for i in 0..<playListList.count {
            let playListData = playListList[i]
            if cell.placeName.text == playListData.dataToString(forKey: "location") {
                cell.playListList.append(playListData)
            }
        }
        cell.PlacePlayListCollectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIScreen.main.bounds.width / UIScreen.main.bounds.height) <= 9/19 {
            return UIScreen.main.bounds.height * 0.40
        } else {
            return UIScreen.main.bounds.height * 0.5
        }
            
    }
}

extension PlacePlayListViewController: collectionViewCellClicked, collectionViewCelEditButtonlClicked {
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
                let appleAlert = UIAlertController(title: "정말 내보내시겠어요?", message: "'\(self.playListList[indexPath].dataToString(forKey: "title"))'으로 저장됩니다.", preferredStyle: .alert)
                let appleCancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                let addPlayList = UIAlertAction(title: "플레이리스트 내보내기", style: .default) { _ in
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
                if #available(iOS 16.0, *) {
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
    
    func cellClicked(indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "PlayListDetailView", bundle: nil)
        guard let playListDetailViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListDetailView") as? PlayListDetailViewController else { return }
        playListDetailViewController.playList = (playListList[indexPath.row] as! PlayListDB)
        self.navigationController?.pushViewController(playListDetailViewController, animated: true)
    }
    
}
