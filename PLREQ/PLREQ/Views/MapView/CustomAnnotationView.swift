//
//  CustomAnnotationView.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/24.
//  Reference https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    private let boxInset = CGFloat(10)
//    private let interItemSpacing = CGFloat(10)
    private let maxContentWidth = CGFloat(50)
    private let contentInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)

    private let blurEffect = UIBlurEffect(style: .systemThickMaterial)
    private lazy var backgroundMaterial: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let upperStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView])
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        upperStackView.axis = .horizontal
        upperStackView.alignment = .top
//        upperStackView.distribution = .fillEqually

        let lowerStackView = UIStackView(arrangedSubviews: [thirdImageView, fourthImageView])
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.axis = .horizontal
        lowerStackView.alignment = .top
//        lowerStackView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [upperStackView, lowerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
//        stackView.distribution = .fillEqually
//        stackView.spacing = interItemSpacing

        return stackView
    }()

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

        backgroundMaterial.contentView.addSubview(stackView)

        backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

        stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: contentInsets.left).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: contentInsets.top).isActive = true

        firstImageView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
        secondImageView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
        thirdImageView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
        fourthImageView.widthAnchor.constraint(equalToConstant: maxContentWidth).isActive = true
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

            if let imageName = annotation.imageName, let image = UIImage(named: imageName) {
                firstImageView.image = image
                secondImageView.image = image
                thirdImageView.image = image
                fourthImageView.image = image

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
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()

//        let contentSize = intrinsicContentSize
//        frame.size = intrinsicContentSize
//
//         TODO: - 가르키기 위해 뾰족한 부분 수정하기
//        centerOffset = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
//
//        let shape = CAShapeLayer()
//        let path = CGMutablePath()
//
//        // Draw the pointed shape.
//        let pointShape = UIBezierPath()
//        pointShape.move(to: CGPoint(x: boxInset, y: 0))
//        pointShape.addLine(to: CGPoint.zero)
//        pointShape.addLine(to: CGPoint(x: boxInset, y: boxInset))
//        path.addPath(pointShape.cgPath)
//
//        // Draw the rounded box.
//        let box = CGRect(x: boxInset, y: 0, width: self.frame.size.width - boxInset, height: self.frame.size.height)
//        let roundedRect = UIBezierPath(roundedRect: box,
//                                       byRoundingCorners: [.topRight, .bottomLeft, .bottomRight],
//                                       cornerRadii: CGSize(width: 5, height: 5))
//        path.addPath(roundedRect.cgPath)
//
//        shape.path = path
//        backgroundMaterial.layer.mask = shape
    }
    
    override var intrinsicContentSize: CGSize {
        var size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width += contentInsets.left + contentInsets.right
//        size.height += contentInsets.top + contentInsets.bottom
        size.height = size.width
        return size
    }
}
