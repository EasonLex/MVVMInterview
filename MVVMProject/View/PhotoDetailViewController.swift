//
//  PhotoDetailViewController.swift
//  MVVMProject
//
//  Created by EasonLin on 2021/2/22.
//

import UIKit
import AlamofireImage

class PhotoDetailViewController: UIViewController {
    var imageUrl: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)!
            imageView.af.setImage(withURL: url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}
