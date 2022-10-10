//
//  PlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit

struct PlayList {
    let title: String
    let date: Date
    let location: String
    let firstImageURL: URL
    let secondImageURL: URL
    let thirdImageURL: URL
    let fourthImageURL: URL
}

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var recentButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var playListButtonStackView: UIStackView!
    @IBOutlet weak var RecentPlayListContainerView: UIView!
    @IBOutlet weak var PlacePlayListContainerView: UIView!
    
    let recentPlayListViewSegue: String = "RecentPlayListViewContainer"
    let placePlayListViewSegue: String = "PlacePlayListViewContainer"
    
    let playListList: [PlayList] = [
        PlayList(title: "을지로 가맥", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/G5BJ35MVUR1FY1UbswJdJUZQK6WynLqI4OZTWw76vERV4V9WiPUllt4ZEz297GKqcqZsbPqzJomJfW0=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/ztYiQ1G-ifyBLm2mhVANYpkIOFciiNZMwNTKr2kwm7FEM3VUi-8L68m7TFOaH7CBmYjkytqMw8QQXMRt=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/sfZHJFUzpft18lZ5hAqpjEk7ybrvJcZMTXfjPXSoK883po7xEO_R3FLqiCmfmQ0sSZaoOqbDMEzYjLw=w544-h544-l90-rj")!),
        PlayList(title: "지곡회관에서 다 같이 부르던 노래", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        PlayList(title: "비 내리던 성수동", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/_PjYBoDL7ynD1C3vvz0-1gHhS0vyr8DPBh-pjV1BNXTh_lYpLuOrGzspcAZByBt1CSeFaam8-oTUG86r=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/3-3rmiGJMA5kqxgpm2pn_BmV1cv_mhI1FkudHbQSDLG9mPuIGvdko-RmJbyHdU7oEKIx8Tfg78ETo_q1=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/CyGv-TmSvL4Fxl-RdWjIPsCLN6S0xa-qNXsBysQ5_6qONrR8ttwXOTFw-BRnMvjMzwxRGL9Q4LCj-fKH=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/C92STuA-ip5wlQ65qPUiBt6iJaeb-eabyloze9dMqPQHXXKM8jAjT7vWRcpjL11zZzwPYpR356MHe8Nq=w544-h544-l90-rj")!),
        PlayList(title: "E 콜로세움에서 듣던 노래", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/x6DZfL7FLCPal3XU5OK8IQ6WdOW1ayORz5WiitE1WSBDVKL-1kEKFWYFvvKfSi2o4gEKaiHlEEeuBTnC=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/Sib0iu5OeDhdNdinJo1PrBqmlTQK0o3TULoxpJTFeYKZnS8CDrR6fJPOurpfM8q2GXWR-jT4enaIDYB2hw=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/NUax_qKBzrOwLI5r4jVUchXSlGjq63xLHFbmMOM36m0uilr_h9eaFKZb2paVVWccu9ZWkhOB-0rQBALH=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/JFhSIMbW4n1vdfoyqQbSpUn9PPdvpL44k4liD9ngho3ik48aTjxlJsOzuGhdymh9Hm9t1JSErEKoS4p4=w544-h544-l90-rj")!),
        PlayList(title: "황리단길 구석 숨은 카페", date: Date(), location: "경주시 >", firstImageURL: URL(string: "https://tistory1.daumcdn.net/tistory/4386109/attach/4dc4a9330fb242ec8ecbeca6e459db47")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/G5BJ35MVUR1FY1UbswJdJUZQK6WynLqI4OZTWw76vERV4V9WiPUllt4ZEz297GKqcqZsbPqzJomJfW0=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/ztYiQ1G-ifyBLm2mhVANYpkIOFciiNZMwNTKr2kwm7FEM3VUi-8L68m7TFOaH7CBmYjkytqMw8QQXMRt=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/sfZHJFUzpft18lZ5hAqpjEk7ybrvJcZMTXfjPXSoK883po7xEO_R3FLqiCmfmQ0sSZaoOqbDMEzYjLw=w544-h544-l90-rj")!),
        PlayList(title: "동성로 선곡 좋던 술집", date: Date(), location: "대구시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        PlayList(title: "석촌호수에서 데이트하고 갔던 카페", date: Date(), location: "서울시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!),
        PlayList(title: "홍자 따라갔던 구석 카페", date: Date(), location: "포항시 >", firstImageURL: URL(string: "https://lh3.googleusercontent.com/N05ScoheX4GQydoi_CO2CxyYZPuFdJ7faBtYngLco5lWTskhNwsB1DuykR5QrEVWQuqMuTM_6CmaLg4=w544-h544-l90-rj")!, secondImageURL: URL(string: "https://lh3.googleusercontent.com/EMO0yIZp463wd_9hduzAwXc2D_YqS1djD7WDe5ipXmK9ZbNuvY0_j-0QqVmH6pcqk_gUZmc5xNgWhDs=w544-h544-l90-rj")!, thirdImageURL: URL(string: "https://lh3.googleusercontent.com/pfRt8Wdw2pBSi39h8fpyUkfol51ZRocytunDNGZWuDuoPzhF0TplmzL5h5_VR9Vt_oWBJambj8qS19C2nQ=w544-h544-l90-rj")!, fourthImageURL: URL(string: "https://lh3.googleusercontent.com/x87vTXqhZYY2VGMTmXkbCJG-3l58O37sFVsA9pluP6nxXanJrNs-uFYezP9W3CDg152MYmyOZQEYTG2V=w544-h544-l90-rj")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        recentButton.layer.addBorder([.bottom], color: .white, width: 2)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //storyboard에서 설정한 identifier와 동일한 이름
        if segue.identifier == recentPlayListViewSegue {
            let containerVC = segue.destination as! RecentPlayListViewController
            containerVC.playListList = playListList
        }
        
        if segue.identifier == placePlayListViewSegue {
            let containerVC = segue.destination as! PlacePlayListViewController
            containerVC.playListList = playListList
        }
    }
    
    @IBAction func selecButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "최근" {
            RecentPlayListContainerView.isHidden = false
            PlacePlayListContainerView.isHidden = true
            recentButton.layer.addBorder([.bottom], color: .white, width: 2)
            placeButton.layer.addBorder([.bottom], color: .black, width: 2)
        } else {
            RecentPlayListContainerView.isHidden = true
            PlacePlayListContainerView.isHidden = false
            placeButton.layer.addBorder([.bottom], color: .white, width: 2)
            recentButton.layer.addBorder([.bottom], color: .black, width: 2)
        }
    }
    
    private func setButton() {
        [recentButton, placeButton].forEach {
            $0.titleLabel?.textColor = .white
            if $0 == recentButton {
                $0.titleLabel?.setLable(text: "최근", fontSize: 20)
            } else {
                $0.titleLabel?.setLable(text: "지역", fontSize: 20)
            }
        }
        RecentPlayListContainerView.isHidden = false
        PlacePlayListContainerView.isHidden = true
        
        playListButtonStackView.isLayoutMarginsRelativeArrangement = true
        playListButtonStackView.layoutMargins = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 18, bottom: 0, right: UIScreen.main.bounds.width / 18)
        playListButtonStackView.layer.addBorder([.bottom], color: .gray, width: 1)

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

