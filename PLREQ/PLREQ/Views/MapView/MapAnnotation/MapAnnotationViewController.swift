//
//  MapAnnotationViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/13.
//

import UIKit

class AnnotationView: UIView
{
    private var firstImageView: UIImageView!
    private var secondImageView: UIImageView!
    private var thirdImageView: UIImageView!
    private var fourthImageView: UIImageView!

    
    init()
    {
        super.init(frame: .zero)
        configureSubView()
        configureImageView()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the background view behind the image
    private func configureSubView()
    {
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(thirdImageView)
        addSubview(fourthImageView)
    }
    
    private func configureImageView()
    {
        firstImageView.load(url: playListList[0].firstImageURL)
        secondImageView.load(url: playListList[0].secondImageURL)
        thirdImageView.load(url: playListList[0].thirdImageURL)
        fourthImageView.load(url: playListList[0].fourthImageURL)
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

let playListList: [TempPlayList] = [
        TempPlayList(title: "을지로 가맥", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/G5BJ35MVUR1FY1UbswJdJUZQK6WynLqI4OZTWw76vERV4V9WiPUllt4ZEz297GKqcqZsbPqzJomJfW0=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/ztYiQ1G-ifyBLm2mhVANYpkIOFciiNZMwNTKr2kwm7FEM3VUi-8L68m7TFOaH7CBmYjkytqMw8QQXMRt=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/sfZHJFUzpft18lZ5hAqpjEk7ybrvJcZMTXfjPXSoK883po7xEO_R3FLqiCmfmQ0sSZaoOqbDMEzYjLw=w544-h544-l90-rj")!),
        TempPlayList(title: "지곡회관에서 다 같이 부르던 노래", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        TempPlayList(title: "비 내리던 성수동", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/_PjYBoDL7ynD1C3vvz0-1gHhS0vyr8DPBh-pjV1BNXTh_lYpLuOrGzspcAZByBt1CSeFaam8-oTUG86r=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/3-3rmiGJMA5kqxgpm2pn_BmV1cv_mhI1FkudHbQSDLG9mPuIGvdko-RmJbyHdU7oEKIx8Tfg78ETo_q1=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/CyGv-TmSvL4Fxl-RdWjIPsCLN6S0xa-qNXsBysQ5_6qONrR8ttwXOTFw-BRnMvjMzwxRGL9Q4LCj-fKH=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/C92STuA-ip5wlQ65qPUiBt6iJaeb-eabyloze9dMqPQHXXKM8jAjT7vWRcpjL11zZzwPYpR356MHe8Nq=w544-h544-l90-rj")!),
        TempPlayList(title: "E 콜로세움에서 듣던 노래", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/x6DZfL7FLCPal3XU5OK8IQ6WdOW1ayORz5WiitE1WSBDVKL-1kEKFWYFvvKfSi2o4gEKaiHlEEeuBTnC=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/Sib0iu5OeDhdNdinJo1PrBqmlTQK0o3TULoxpJTFeYKZnS8CDrR6fJPOurpfM8q2GXWR-jT4enaIDYB2hw=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/NUax_qKBzrOwLI5r4jVUchXSlGjq63xLHFbmMOM36m0uilr_h9eaFKZb2paVVWccu9ZWkhOB-0rQBALH=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/JFhSIMbW4n1vdfoyqQbSpUn9PPdvpL44k4liD9ngho3ik48aTjxlJsOzuGhdymh9Hm9t1JSErEKoS4p4=w544-h544-l90-rj")!),
        TempPlayList(title: "황리단길 구석 숨은 카페", date: Date(), location: "경주시 >", firstImageURL: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/G5BJ35MVUR1FY1UbswJdJUZQK6WynLqI4OZTWw76vERV4V9WiPUllt4ZEz297GKqcqZsbPqzJomJfW0=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/ztYiQ1G-ifyBLm2mhVANYpkIOFciiNZMwNTKr2kwm7FEM3VUi-8L68m7TFOaH7CBmYjkytqMw8QQXMRt=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/sfZHJFUzpft18lZ5hAqpjEk7ybrvJcZMTXfjPXSoK883po7xEO_R3FLqiCmfmQ0sSZaoOqbDMEzYjLw=w544-h544-l90-rj")!),
        TempPlayList(title: "동성로 선곡 좋던 술집", date: Date(), location: "대구시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        TempPlayList(title: "석촌호수에서 데이트하고 갔던 카페", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        TempPlayList(title: "홍자 따라갔던 구석 카페", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!)
]