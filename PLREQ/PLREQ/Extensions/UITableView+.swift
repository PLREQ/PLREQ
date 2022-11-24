//
//  UIImage+.swift
//  PLREQ
//
//  Created by 이성노 on 2022/10/17.
//

import UIKit

extension UITableView {
    
    func convertImage() -> UIImage {
        var image = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)

        self.contentOffset = CGPoint(x: 0, y: 0)
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height))
        
        let tempSuperView = self.superview
        
        guard let superView = tempSuperView else {
            return UIImage()
        }
        
        var previousConstraints: [NSLayoutConstraint] = []
        for constraint in superView.constraints {
            let constraintFirstItem = constraint.firstItem as? NSObject
            let constraintSecondtItem = constraint.secondItem as? NSObject

            if constraintFirstItem == self || constraintSecondtItem == self {
                previousConstraints.append(constraint)
            }
        }

        tempView.addSubview(self)
        tempView.layer.render(in: UIGraphicsGetCurrentContext() ?? "" as! CGContext)
        
        image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        tempSuperView?.addSubview(self)
        
        NSLayoutConstraint.activate(previousConstraints)

        UIGraphicsEndImageContext()
        
        return image
    }
}
