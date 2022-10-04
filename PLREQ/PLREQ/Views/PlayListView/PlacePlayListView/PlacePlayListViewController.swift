//
//  PlacePlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit

class PlacePlayListViewController: UIViewController {
    
    @IBOutlet weak var PlacePlayListTableView: UITableView!
    
    var playListList: [PlayList] = []
    var placeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableViewLink()
        // Do any additional setup after loading the view.
    }
    
    private func registerNib() {
        PlacePlayListTableView.register(UINib(nibName: "PlacePlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacePlayListTableViewCell")
    }
    
    private func tableViewLink() {
        self.PlacePlayListTableView.delegate = self
        self.PlacePlayListTableView.dataSource = self
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
        for i in 0..<playListList.count {
            var check: Bool = false
            if placeList.isEmpty {
                placeList.append(playListList[i].location)
            } else {
                for j in 0..<placeList.count {
                    if playListList[i].location == self.placeList[j] {
                        check.toggle()
                        break
                    }
                }
                if !check {
                    placeList.append(playListList[i].location)
                }
            }
        }
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlacePlayListTableViewCell", for: indexPath) as? PlacePlayListTableViewCell else { return UITableViewCell() }
        cell.placeName.text = placeList[indexPath.row]
        for i in 0..<playListList.count {
            if cell.placeName.text == playListList[i].location {
                cell.playListList.append(playListList[i])
            }
        }
        return cell
    }

}
