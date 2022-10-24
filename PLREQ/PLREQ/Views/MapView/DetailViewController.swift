//
//  DetailViewController.swift
//  PLREQ
//
//  Created by Yeni Hwang on 2022/10/24.
//  Reference https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = imageView.image {
            preferredContentSize = image.size
        }
    }
    
    @IBAction private func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
