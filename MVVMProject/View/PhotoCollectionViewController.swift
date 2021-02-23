//
//  PhotoListViewController.swift
//  MVVMProject
//
//  Created by EasonLin on 2021/2/22.
//

import UIKit

class PhotoCollectionViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
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
                    self?.collectionView.alpha = 1.0;
                })
                self?.collectionView.reloadData();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as? PhotoCollectionCell else {
            fatalError("Cell does not exists")
        }

        let photo = self.photos[indexPath.row]
        let url = URL(string: photo.thumbnailUrl)!
        cell.bgImgView.af.setImage(withURL: url)
        
        cell.idLabel.text = "\(photo.id)";
        cell.titleLabel.text = photo.title;
        
//        cell.titleLabel.text = photo.title;
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count;
    }
}

extension PhotoCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController,
           let indexPath = self.selectedIndexPath {
            let photo = self.photos[indexPath.row]
            vc.imageUrl = photo.thumbnailUrl;
        }
    }
}

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
