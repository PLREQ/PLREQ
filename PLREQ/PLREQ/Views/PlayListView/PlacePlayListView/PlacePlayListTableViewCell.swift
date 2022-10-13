//
//  PlacePlayListTableViewCell.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/03.
//

import UIKit
import CoreData

class PlacePlayListTableViewCell: UITableViewCell, collectionViewCelEditButtonlClicked {
    func buttonClicked(indexPath: Int) {
        editDelegate?.buttonClicked(indexPath: indexPath)
    }
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var PlacePlayListCollectionView: UICollectionView!
    
    var playListList: [NSManagedObject] = []
    let width = UIScreen.main.bounds.width * 0.9589
    let playListCollectionViewCellNib: UINib = UINib(nibName: "PlayListCollectionViewCell", bundle: nil)
    let playListCollectionViewCell: String = "PlayListCollectionViewCell"
    var delegate: collectionViewCellClicked?
    var editDelegate: collectionViewCelEditButtonlClicked?
    var dataCheck: Bool = false {
        didSet {
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        setAutoLayout()
        collectionViewLink()
        registerNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func collectionViewLink() {
        self.PlacePlayListCollectionView.delegate = self
        self.PlacePlayListCollectionView.dataSource = self
    }
    
    private func setAutoLayout() {
        var height = UIScreen.main.bounds.height * 0.4146
        if !((UIScreen.main.bounds.width / UIScreen.main.bounds.height) <= 9/19) {
            height = UIScreen.main.bounds.height * 0.5
        }
        placeName.translatesAutoresizingMaskIntoConstraints = false
        placeName.widthAnchor.constraint(equalToConstant: width).isActive = true
        placeName.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        placeName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0 ).isActive = true
        placeName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(height * 0.9) ).isActive = true
        
        PlacePlayListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        PlacePlayListCollectionView.widthAnchor.constraint(equalToConstant: width).isActive = true
        if (UIScreen.main.bounds.width / UIScreen.main.bounds.height) <= 9/19 {
            PlacePlayListCollectionView.heightAnchor.constraint(equalToConstant: height * (7.5/10)).isActive = true
            PlacePlayListCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: height / 10 ).isActive = true
        } else {
            PlacePlayListCollectionView.heightAnchor.constraint(equalToConstant: height * (7.5/10)).isActive = true
            PlacePlayListCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: height / 9 ).isActive = true
        }
        
        PlacePlayListCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0 ).isActive = true
        PlacePlayListCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10 ).isActive = true
    }
    
    private func registerNib() {
        self.PlacePlayListCollectionView.register(playListCollectionViewCellNib, forCellWithReuseIdentifier: playListCollectionViewCell)
    }
    
}

extension PlacePlayListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCollectionViewCell, for: indexPath) as? PlayListCollectionViewCell else { return UICollectionViewCell()}
        
        let playListData = playListList[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath.row
        cell.PlayListImageArr[0].load(url: playListData.dataToURL(forKey: "firstImageURL"))
        cell.PlayListImageArr[1].load(url: playListData.dataToURL(forKey: "secondImageURL"))
        cell.PlayListImageArr[2].load(url: playListData.dataToURL(forKey: "thirdImageURL"))
        cell.PlayListImageArr[3].load(url: playListData.dataToURL(forKey: "fourthImageURL"))
        
        cell.playListName.setLable(text: playListData.dataToString(forKey: "title"), fontSize: 14)

        cell.playListDay.setLable(text: Date().toYMDString(date: playListData.dataToDate(forKey: "day")), fontSize: 12)
        cell.layer.cornerRadius = UIScreen.main.bounds.width / 2.3375 / 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellClicked(indexPath: indexPath)
    }
}

extension PlacePlayListTableViewCell: UICollectionViewDelegateFlowLayout {
    // cell 사이즈( 옆 라인을 고려하여 설정 )

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2.3375
        let size = CGSize(width: width, height: width * 25 / 16 )
//        let size = CGSize(width: 160, height: 250)
        return size
    }
}
