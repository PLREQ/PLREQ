//
//  PlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit
import CoreData
import SwiftUI
import Combine

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var recentButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var playListButtonStackView: UIStackView!
    @IBOutlet weak var RecentPlayListContainerView: UIView!
    @IBOutlet weak var PlacePlayListContainerView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    var buttonCheck: Bool = false
    let recentPlayListViewSegue: String = "RecentPlayListViewContainer"
    let placePlayListViewSegue: String = "PlacePlayListViewContainer"
    let bounds = UIScreen.main.bounds
    var playListList: [NSManagedObject] {
        return PLREQDataManager.shared.fetch()
    }
    @ObservedObject var checkAppleMusicSubscription = CheckAppleMusicSubscription.shared
    var cancelBag = Set<AnyCancellable>()
    var isCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        self.checkAppleMusicSubscription.$check
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if self.isCheck {
                    if !self.checkAppleMusicSubscription.check {
                        self.checkMusicSubscirption()
                    } else {
                        if let appleMusic = URL(string: "music://"), UIApplication.shared.canOpenURL(appleMusic) {
                            UIApplication.shared.open(appleMusic, options: [:], completionHandler: nil)
                        }
                    }
                }
                self.isCheck = true
            })
            .store(in: &self.cancelBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !buttonCheck {
            recentButton.layer.addBorder([.bottom], color: .white, width: 2)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //storyboard에서 설정한 identifier와 동일한 이름
        if segue.identifier == recentPlayListViewSegue {
            let containerVC = segue.destination as! RecentPlayListViewController
            containerVC.playListList = playListList
        }
        
        if segue.identifier == placePlayListViewSegue {
            let containerVC = segue.destination as! PlacePlayListViewController
            containerVC.playListList = playListList
        }
    }
    
    @IBAction func goToBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goToMap(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "MapView", bundle: nil)
        guard let mapViewViewController = storyBoard.instantiateViewController(withIdentifier: "MapView") as? MapViewController else { return }
        self.navigationController?.pushViewController(mapViewViewController, animated: true)
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "최근" {
            RecentPlayListContainerView.isHidden = false
            PlacePlayListContainerView.isHidden = true
            recentButton.layer.addBorder([.bottom], color: .white, width: 2)
            placeButton.layer.addBorder([.bottom], color: .black, width: 2)
            if #available(iOS 16.0, *) {
                mapButton.isHidden = true
            }
            buttonCheck = false
        } else {
            RecentPlayListContainerView.isHidden = true
            PlacePlayListContainerView.isHidden = false
            placeButton.layer.addBorder([.bottom], color: .white, width: 2)
            recentButton.layer.addBorder([.bottom], color: .black, width: 2)
            if #available(iOS 16.0, *) {
                mapButton.isHidden = false
            }
            buttonCheck = true
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
        if #available(iOS 16.0, *) {
            mapButton.isHidden = true
        }
        playListButtonStackView.isLayoutMarginsRelativeArrangement = true
        playListButtonStackView.layoutMargins = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 18, bottom: 0, right: UIScreen.main.bounds.width / 18)
        playListButtonStackView.layer.addBorder([.bottom], color: .gray, width: 1)
        
    }
    
    private func checkMusicSubscirption() {
        let appleAlert = UIAlertController(title: "애플 뮤직을 구독중인지 확인해주세요.", message: "애플 뮤직을 구독하고 계시지않으면 내보내기를 할 수 없어요.", preferredStyle: .alert)
        let appleConfirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        appleAlert.addAction(appleConfirm)
        self.present(appleAlert, animated: true, completion: nil)
    }
    
}
