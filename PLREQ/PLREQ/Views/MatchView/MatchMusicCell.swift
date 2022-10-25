//
//  MatchMusicCell.swift
//  PLREQ
//
//  Created by 이영준 on 2022/10/01.
//

import UIKit

class MatchMusicCell: UICollectionViewCell {
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    
    override func layoutSubviews() {
        self.musicTitle.textColor = UIColor.white
        self.musicTitle.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        self.musicTitle.font = .systemFont(ofSize: 20, weight: .regular)
        self.musicArtist.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.musicArtist.font = .systemFont(ofSize: 16, weight: .light)
        self.musicImage.layer.cornerRadius = 10
    }
}
