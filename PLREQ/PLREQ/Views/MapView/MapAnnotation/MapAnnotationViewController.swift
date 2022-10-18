//
//  MapAnnotationViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/13.
//

import UIKit

class AnnotationView: UIView {
    private var firstImageView = UIImageView()
    private var secondImageView = UIImageView()
    private var thirdImageView = UIImageView()
    private var fourthImageView = UIImageView()

    init() {
        super.init(frame: .zero)
        DispatchQueue.main.async {
            self.configureImageView()
            self.configureSubView()
//
//            self.addSubview(self.firstImageView)
//            self.addSubview(self.secondImageView)
//            self.addSubview(self.thirdImageView)
//            self.addSubview(self.fourthImageView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure the background view behind the image
    private func configureSubView() {
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(thirdImageView)
        addSubview(fourthImageView)
    }

    private func configureImageView() {
        firstImageView.load(url: URL(string:"http://t1.daumcdn.net/thumb/R600x0/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fqna%2Fimage%2F4b035cdf8372d67108f7e8d339660479dfb41bbd")!)
        secondImageView.load(url: URL(string:"http://t1.daumcdn.net/thumb/R600x0/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fqna%2Fimage%2F4b035cdf8372d67108f7e8d339660479dfb41bbd")!)
        thirdImageView.load(url: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!)
        fourthImageView.load(url: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!)
    }
}

struct TempPlayList {
    let title: String
    let date: Date
    let location: String
    let firstImageURL: URL
    let secondImageURL: URL
    let thirdImageURL: URL
    let fourthImageURL: URL
}

