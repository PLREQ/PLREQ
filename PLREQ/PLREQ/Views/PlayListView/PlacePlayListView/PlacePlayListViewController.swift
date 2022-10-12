//
//  PlacePlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit
import CoreData

class PlacePlayListViewController: UIViewController, collectionViewCellClicked {
    func cellClicked(indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "PlayListDetailView", bundle: nil)
        guard let playListDetailViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListDetailView") as? PlayListDetailViewController else { return }
        playListDetailViewController.playList = (playListList[indexPath.row] as! PlayListDB)
        self.navigationController?.pushViewController(playListDetailViewController, animated: true)
    }
    
    @IBOutlet weak var PlacePlayListTableView: UITableView!
    let placePlayListTableViewCellNib: UINib = UINib(nibName: "PlacePlayListTableViewCell", bundle: nil)
    let placePlayListTableViewCell: String = "PlacePlayListTableViewCell"
    
    var playListList: [NSManagedObject] = []
    var placeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableViewLink()
        setAutoLayout()
        // Do any additional setup after loading the view.
    }
    
    private func registerNib() {
        PlacePlayListTableView.register(placePlayListTableViewCellNib, forCellReuseIdentifier: placePlayListTableViewCell)
    }
    
    private func tableViewLink() {
        self.PlacePlayListTableView.delegate = self
        self.PlacePlayListTableView.dataSource = self
    }
    
    private func setAutoLayout() {
        self.PlacePlayListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.PlacePlayListTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0 ).isActive = true
        self.PlacePlayListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.PlacePlayListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width / 20).isActive = true
        self.PlacePlayListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
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
        cell.delegate = self
        cell.placeName.setLable(text: placeList[indexPath.row], fontSize: 18)
        // 테이블뷰의 이름과 플레이리스트안의 지역 이름을 비교하여 테이블뷰 안의 컬렉션 뷰 셀의 갯수를 미리 지정
        for i in 0..<playListList.count {
            let playListData = playListList[i]
            if cell.placeName.text == playListData.dataToString(forKey: "location") {
                cell.playListList.append(playListData)
            }
        }
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
