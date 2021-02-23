//
//  PhotoListViewController.swift
//  MVVMProject
//
//  Created by EasonLin on 2021/2/22.
//

import UIKit

class PhotoListViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photos: [Photo] = [Photo]()
    var selectedIndexPath: IndexPath?;
    
    lazy var apiFetch: APIFetch = {
        return APIFetch()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationItem.title = "Photo List";
        
        fetchData();
    }
    
    func fetchData() {
        apiFetch.fetchImgList { [weak self] (success, photoList, error) in
            DispatchQueue.main.async {
                self?.photos = photoList;
                
                self?.activityIndicator.stopAnimating();
                UIView.animate(withDuration: 0.3, animations: {
                    self?.tableView.alpha = 1.0;
                })
                self?.tableView.reloadData();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCellId", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell does not exists")
        }
        
        let photo = self.photos[indexPath.row]
        cell.nameLabel.text = photo.title;
        cell.dateLabel.text = "\(photo.id)";
        
        let url = URL(string: photo.thumbnailUrl)!
        cell.mainImgView.af.setImage(withURL: url)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndexPath = indexPath;
        return indexPath;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
}

extension PhotoListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController,
           let indexPath = self.selectedIndexPath {
            let photo = self.photos[indexPath.row]
            vc.imageUrl = photo.thumbnailUrl;
        }
    }
}

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}
