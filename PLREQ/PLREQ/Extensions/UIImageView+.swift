//
//  UIImageView+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/04.
//

import UIKit

extension UIImageView {
    // UIImageView에 URL로 이미지를 불러올 때 사용
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
