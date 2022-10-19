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
        self.musicTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.musicArtist.textColor = UIColor.white
        self.musicArtist.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.musicImage.layer.cornerRadius = 10
    }
}
