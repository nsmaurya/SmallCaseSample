//
//  ViewController.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import UIKit

class SMMainViewController: UIViewController {

    @IBOutlet weak var networkInfoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var mainViewModel: SMMainViewModel = SMMainViewModel()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initNetworkChecker()
    }
    
    //MARK:- Helper method
    private func setUpCollectionLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Device.ScreenSize.width/2-16, height: Device.ScreenSize.width/2-16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.collectionViewLayout = layout
    }
    
    private func initNetworkChecker() {
        let networkManager: NetworkManager = NetworkManager.sharedInstance
        networkManager.networkDelegate = self
        networkManager.initNetworkChecker()
    }
}

//MARK:- Collection View Datasource & Delegate
extension SMMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        if let imageData: Data = mainViewModel.getSCIDImageData(index: indexPath.item), let image: UIImage = UIImage.init(data: imageData) {
            cell.imageView.image = image
        } else {
            if let url: URL = mainViewModel.getSCIDImageUrl(index: indexPath.item) {
                cell.imageView.load(url: url, index: indexPath.item)
            } else {
                cell.imageView.image = nil
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewModel.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let info = mainViewModel.getSCIDInfo(index: indexPath.item) else {
            return
        }
        self.performSegue(withIdentifier: "detail", sender: info)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let smDetailViewController: SMDetailViewController = segue.destination as? SMDetailViewController else {
            return
        }
        if let detailViewModel: SMDetailViewModel = sender as? SMDetailViewModel {
            smDetailViewController.smDetailViewModel = detailViewModel
        }
    }
}

//MARK:- Network Checker Delegate
extension SMMainViewController: NetworkProtocol {
    func networkInfo(isNetworkAvailable: Bool, message: String) {
        self.networkInfoLabel.text = message
        if isNetworkAvailable {
            self.networkInfoLabel.backgroundColor = UIColor.green
        } else {
            self.networkInfoLabel.backgroundColor = UIColor.red
        }
    }
}

//MARK:- CollectionView Cell
class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5.0
    }
}

