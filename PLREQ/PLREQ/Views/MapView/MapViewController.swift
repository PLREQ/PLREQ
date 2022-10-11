//
//  MapViewController.swift
//  PLREQ
//
//  Created by 이주화 on 2022/09/27.
//

import UIKit
import CoreData

class MapViewController: UIViewController {
    
    var playListList: [NSManagedObject] {
        return PLREQDataManager.shared.fetch()
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
