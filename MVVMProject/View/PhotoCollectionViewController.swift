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
        cell.titleLabel.text = photo.title;
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count;
    }
}
//extension PhotoCollectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCellId", for: indexPath) as? PhotoListTableViewCell else {
//            fatalError("Cell does not exists")
//        }
//
//        let photo = self.photos[indexPath.row]
//        cell.nameLabel.text = photo.title;
//
//        return cell;
//    }
//
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        self.selectedIndexPath = indexPath;
//        return indexPath;
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1;
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.photos.count;
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150;
//    }
//}

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
//    @IBOutlet weak var bgImgView: UIImageView!
//    @IBOutlet weak var idLabel: UILabel!
    var imageView:UIImageView!
    var titleLabel:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 取得螢幕寬度
        let w = Double(UIScreen.main.bounds.size.width)

        // 建立一個 UIImageView
        imageView = UIImageView(frame: CGRect(
          x: 0, y: 0,
          width: w/4 - 10.0, height: w/4 - 10.0))
        self.addSubview(imageView)

        // 建立一個 UILabel
        titleLabel = UILabel(frame:CGRect(
          x: 0, y: 0, width: w/4 - 10.0, height: 40))
        titleLabel.textAlignment = .center
//            titleLabel.textColor = UIColor.orangeColor()
        self.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
