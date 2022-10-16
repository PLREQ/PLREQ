//
//  PlayListCollectionViewCell.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var PlayListImageArr: [UIImageView]!
    @IBOutlet weak var playListName: UILabel!
    @IBOutlet weak var playListDay: UILabel!
    let width = UIScreen.main.bounds.width / 2.4375
    let padding = UIScreen.main.bounds.width
    var delegate: collectionViewCelEditButtonlClicked?
    var indexPath: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        setLayout()
        self.playListName.sizeToFit()
    }
    
    @IBAction func clickEditButton(_ sender: Any) {
        delegate?.buttonClicked(indexPath: indexPath)
    }
    
    private func setLayout() {
        let imageWidth = self.frame.width / 2
        
        playListName.translatesAutoresizingMaskIntoConstraints = false
        playListName.widthAnchor.constraint(equalToConstant: width - 20).isActive = true
        playListName.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height / (25/18) ).isActive = true
        playListName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10 ).isActive = true
        playListName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10 ).isActive = true
        
        playListDay.translatesAutoresizingMaskIntoConstraints = false
        playListDay.widthAnchor.constraint(equalToConstant: width - 20).isActive = true
        playListDay.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height / (25/22) ).isActive = true
        playListDay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10 ).isActive = true
        playListDay.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10 ).isActive = true
        
        PlayListImageArr.forEach { PlayListImage in
            PlayListImage.translatesAutoresizingMaskIntoConstraints = false
            PlayListImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
            PlayListImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        }
        
        PlayListImageArr[0].topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        PlayListImageArr[0].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        PlayListImageArr[1].topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        PlayListImageArr[1].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        PlayListImageArr[2].topAnchor.constraint(equalTo: self.topAnchor, constant: imageWidth ).isActive = true
        PlayListImageArr[2].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        PlayListImageArr[3].topAnchor.constraint(equalTo: self.topAnchor, constant: imageWidth ).isActive = true
        PlayListImageArr[3].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        PlayListImageArr[0].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -imageWidth).isActive = true
        
        editButton.transform = CGAffineTransformMakeRotation(CGFloat(Double.pi / 2))
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.widthAnchor.constraint(equalToConstant: imageWidth / 3).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: imageWidth / 1.8).isActive = true
        editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0 ).isActive = true
    }
}

