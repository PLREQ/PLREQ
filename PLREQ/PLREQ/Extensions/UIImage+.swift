//
//  UIImage+.swift
//  PLREQ
//
//  Created by 이성노 on 2022/10/17.
//

import UIKit

extension UIImage {
    func shareWithImage(tableView: UITableView) -> UIImage {
        var image = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, UIScreen.main.scale)
        
        // 초기값을 저장합니다.
        let savedContentOffset = tableView.contentOffset
        let savedFrame = tableView.frame
        let savedBackgroundColor = tableView.backgroundColor
        
        // offset을 좌표(0, 0)으로 설정합니다.
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        
        // frame을 content 크기로 설정합니다.
        tableView.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height)
        
        // ScrollView 크기로 tempView 생성
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height))
        
        // Superview를 저장합니다.
        let tempSuperView = tableView.superview
        
        // Constraints를 저장합니다.
        guard let superView = tempSuperView else {
            return UIImage()
        }
        
        // tableView에서 이전의 constraints를 받아옵니다.
        var previousConstraints: [NSLayoutConstraint] = []
        for constraint in superView.constraints {
            if constraint.firstItem as? NSObject == tableView || constraint.secondItem as? NSObject == tableView {
                previousConstraints.append(constraint)
            }
        }
        
        // old superView에서 scrollView를 제거합니다.
        tableView.removeFromSuperview()
        
        // 그러곤 tempView에 추가해줍니다.
        tempView.addSubview(tableView)
        
        // view를 render해줍니다.
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // 이미지를 받아옵니다.
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(tableView)
        
        // oldConstraints를 활성화합니다.
        NSLayoutConstraint.activate(previousConstraints)
        
        // 가공된 값을 넣어줍니다.
        tableView.contentOffset = savedContentOffset
        tableView.frame = savedFrame
        tableView.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
