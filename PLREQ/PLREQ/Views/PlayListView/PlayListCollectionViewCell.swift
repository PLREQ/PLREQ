//
//  PlayListCollectionViewCell.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var PlayListImageArr: [UIImageView]!
    @IBOutlet weak var playListName: UILabel!
    @IBOutlet weak var playListDay: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
}
