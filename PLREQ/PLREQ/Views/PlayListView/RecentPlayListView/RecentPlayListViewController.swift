//
//  RecentPlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit

class RecentPlayListViewController: UIViewController {
    
    @IBOutlet weak var RecentPlayListCollectionView: UICollectionView!
    var playListList: [PlayList] = []
    let playListCollectionViewCellNib: UINib = UINib(nibName: "PlayListCollectionViewCell", bundle: nil)
    let playListCollectionViewCell: String = "PlayListCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLink()
        registerNib()
        // Do any additional setup after loading the view.
    }
    
    private func collectionViewLink() {
        self.RecentPlayListCollectionView.delegate = self
        self.RecentPlayListCollectionView.dataSource = self
    }
    
    private func registerNib() {
        self.RecentPlayListCollectionView.register(playListCollectionViewCellNib, forCellWithReuseIdentifier: playListCollectionViewCell)
    }
    
    private func setAutoLayout() {
        self.RecentPlayListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.RecentPlayListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0 ).isActive = true
        self.RecentPlayListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.RecentPlayListCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width / 20).isActive = true
        self.RecentPlayListCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(self.view.frame.width / 20)).isActive = true
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
        cell.PlayListImageArr[0].load(url: playListList[indexPath.row].firstImageURL)
        cell.PlayListImageArr[1].load(url: playListList[indexPath.row].secondImageURL)
        cell.PlayListImageArr[2].load(url: playListList[indexPath.row].thirdImageURL)
        cell.PlayListImageArr[3].load(url: playListList[indexPath.row].fourthImageURL)
        
        cell.playListName.setLable(text: playListList[indexPath.row].title, fontSize: 14)
        
        cell.playListDay.setLable(text: Date().toYMDString(date: playListList[indexPath.row].date), fontSize: 12)
        
        cell.layer.cornerRadius = self.view.frame.width / 2.3375 / 16
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension RecentPlayListViewController: UICollectionViewDelegateFlowLayout {
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    
    // 윗 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
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
