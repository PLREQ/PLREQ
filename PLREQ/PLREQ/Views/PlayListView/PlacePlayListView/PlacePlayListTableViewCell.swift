//
//  PlacePlayListTableViewCell.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit

class PlacePlayListTableViewCell: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var PlacePlayListCollectionView: UICollectionView!
    var playListList: [PlayList] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewLink()
        registerNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func collectionViewLink() {
        self.PlacePlayListCollectionView.delegate = self
        self.PlacePlayListCollectionView.dataSource = self
    }
    
    private func registerNib() {
        self.PlacePlayListCollectionView.register(UINib(nibName: "PlayListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayListCollectionViewCell")
    }
    
}

extension PlacePlayListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListCollectionViewCell", for: indexPath) as? PlayListCollectionViewCell else { return UICollectionViewCell()}
        cell.PlayListImageArr[0].load(url: playListList[indexPath.row].firstImageURL)
        cell.PlayListImageArr[1].load(url: playListList[indexPath.row].secondImageURL)
        cell.PlayListImageArr[2].load(url: playListList[indexPath.row].thirdImageURL)
        cell.PlayListImageArr[3].load(url: playListList[indexPath.row].fourthImageURL)
        
        cell.playListName.text = playListList[indexPath.row].title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        cell.playListDay.text = dateFormatter.string(from: playListList[indexPath.row].date)
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    
}

extension PlacePlayListTableViewCell: UICollectionViewDelegateFlowLayout {
    // cell 사이즈( 옆 라인을 고려하여 설정 )

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 160, height: 250)
        return size
    }
}
