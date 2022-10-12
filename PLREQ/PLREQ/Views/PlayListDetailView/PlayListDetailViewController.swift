//
//  PlayListDetailViewController.swift
//  PLREQ
//
//  Created by 이성노 on 2022/09/27.
//

import UIKit

class PlayListDetailViewController: UIViewController {
    var playList: PlayListDB!
    var musicList: [MusicDB]! {
        return playList.music?.array as? [MusicDB]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
