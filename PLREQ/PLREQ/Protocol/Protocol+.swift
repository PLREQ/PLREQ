//
//  Protocol+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/12.
//

import Foundation

protocol collectionViewCellClicked {
    func cellClicked(indexPath: IndexPath)
}

protocol collectionViewCelEditButtonlClicked {
    func buttonClicked(indexPath: Int)
}
