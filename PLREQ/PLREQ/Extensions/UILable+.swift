//
//  UILable+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/07.
//

import UIKit

extension UILabel {
    func setLable(text: String, fontSize : CGFloat) {
        self.text = text
        self.font = .systemFont(ofSize: fontSize)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
}
