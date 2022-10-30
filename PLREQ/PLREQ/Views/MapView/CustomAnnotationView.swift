//
//  CustomAnnotationView.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/29.
//
import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    private let boxInset = CGFloat(10)
    private let maxContentWidth = CGFloat(80)
    private let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private lazy var backgroundMaterial: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let upperStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView])
         upperStackView.translatesAutoresizingMaskIntoConstraints = false
         upperStackView.axis = .horizontal
         upperStackView.alignment = .bottom
         upperStackView.distribution = .fillEqually

        let lowerStackView = UIStackView(arrangedSubviews: [thirdImageView, fourthImageView])
         lowerStackView.translatesAutoresizingMaskIntoConstraints = false
         lowerStackView.axis = .horizontal
         lowerStackView.alignment = .top
         lowerStackView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [upperStackView, lowerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .black
         return stackView
     }()

    // Image Views
    private var firstImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()
    
    private var secondImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()

    private var thirdImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()

    private var fourthImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()
    
    
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(backgroundMaterial)
    
        backgroundMaterial.addSubview(stackView)
        
        backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

        stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: backgroundMaterial.trailingAnchor, constant: contentInsets.left).isActive = true
        stackView.bottomAnchor.constraint(equalTo: backgroundMaterial.bottomAnchor, constant: contentInsets.left).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: contentInsets.top).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstImageView.image = nil
        secondImageView.image = nil
        thirdImageView.image = nil
        fourthImageView.image = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let annotation = annotation as? CustomAnnotation {
            
            let imageName = annotation.musicImage
            let image = imageName[0]
            firstImageView.image = imageName[0]
            secondImageView.image = imageName[1]
            thirdImageView.image = imageName[2]
            fourthImageView.image = imageName[3]

            if let heightConstraint = imageHeightConstraint {
                firstImageView.removeConstraint(heightConstraint)
                secondImageView.removeConstraint(heightConstraint)
                thirdImageView.removeConstraint(heightConstraint)
                fourthImageView.removeConstraint(heightConstraint)
            }

            let ratio = image.size.height / image.size.width

            imageHeightConstraint = firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor, multiplier: ratio, constant: 0)
            imageHeightConstraint?.isActive = true
            
            imageHeightConstraint = secondImageView.heightAnchor.constraint(equalTo: secondImageView.widthAnchor, multiplier: ratio, constant: 0)
            imageHeightConstraint?.isActive = true

            imageHeightConstraint = secondImageView.heightAnchor.constraint(equalTo: thirdImageView.widthAnchor, multiplier: ratio, constant: 0)
            imageHeightConstraint?.isActive = true

            imageHeightConstraint = secondImageView.heightAnchor.constraint(equalTo: fourthImageView.widthAnchor, multiplier: ratio, constant: 0)
            imageHeightConstraint?.isActive = true
            
        }
        
        setNeedsLayout()
    }
    
    // 스택뷰의 사이즈를 확정합니다.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()

        let contentSize = intrinsicContentSize
        frame.size = intrinsicContentSize
        
        // annotation View의 Center
        centerOffset = CGPoint(x: 0, y: 0)
        
        // TODO: - 말풍선 꼬리 밑으로
        let shape = CAShapeLayer()
        let path = CGMutablePath()

        // 말풍선 꼬리
        let pointShape = UIBezierPath()
//        pointShape.move(to: CGPoint(x: frame.width / 2, y: frame.height + boxInset))
//        pointShape.addLine(to: CGPoint(x: frame.width / 2 - boxInset, y: frame.height))
//        pointShape.addLine(to: CGPoint(x: frame.width / 2 + boxInset, y: frame.height))
//        path.addPath(pointShape.cgPath)

        // 라운드 프레임
        let box = CGRect(
            x: 0,
            y: 0,
            width: self.frame.size.width,
            height: self.frame.size.height)
        let roundedRect = UIBezierPath(roundedRect: box,
                                       byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                       cornerRadii: CGSize(width: 10, height: 10))
        path.addPath(roundedRect.cgPath)

        shape.path = path
        backgroundMaterial.layer.mask = shape
    }
    
    // 스택뷰의 크기
    override var intrinsicContentSize: CGSize {
        var size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        size.width = (size.width + contentInsets.right + contentInsets.left) * 0.15
//        size.height = (size.height + contentInsets.bottom + contentInsets.top ) * 0.15
        size.width = 100
        size.height = 100
        return size
    }
}
