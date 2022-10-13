//
//  PlayListViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit
import CoreData

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    @IBAction func selecButton(_ sender: UIButton) {
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
