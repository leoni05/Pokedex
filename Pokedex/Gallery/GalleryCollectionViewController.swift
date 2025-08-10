//
//  GalleryCollectionViewController.swift
//  Pokedex
//
//  Created by jyj on 8/10/25.
//

import Foundation
import UIKit
import PinLayout

class GalleryCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView? = nil
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private let inset = 16.0
    private let itemSpacing = 4.0
    private var photos: [Photo] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(indicatorView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: MainUpperView.topInset + inset, left: inset,
                                           bottom: inset, right: inset)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseIdentifier)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
        
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        collectionView.isHidden = true
        DispatchQueue.main.async {
            self.photos = CoreDataManager.shared.getPhotos()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.pin.all()
        collectionView?.pin.all()
    }
    
}

// MARK: - Private Extensions

private extension GalleryCollectionViewController {
    @objc func handleRefreshControl() {
        self.photos = CoreDataManager.shared.getPhotos()
        self.collectionView?.reloadData()
        self.collectionView?.refreshControl?.endRefreshing()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - inset*2 - itemSpacing*3) / 4.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = GalleryDetailViewController()
        detailVC.imageName = photos[indexPath.row].name
        detailVC.delegate = navigationController as? GalleryDetailViewControllerDelegate
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath)
        guard let cell = reusableCell as? GalleryCell,
              let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let imageName = photos[indexPath.row].name else {
            return reusableCell
        }
        
        let thumbnailFileUrl = documentsDirectory.appendingPathComponent(imageName + "_thumbnail", conformingTo: .jpeg)
        if FileManager.default.fileExists(atPath: thumbnailFileUrl.path) {
            cell.setImage(image: UIImage(contentsOfFile: thumbnailFileUrl.path))
        }
        return reusableCell
    }
}
