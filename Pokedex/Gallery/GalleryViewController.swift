//
//  GalleryViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

class GalleryViewController: NavigationController {
    
    // MARK: - Properties

    private let inset = 16.0
    private let itemSpacing = 4.0
    private var collectionVC = UICollectionViewController()
    private var photos: [Photo] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isNavigationBarHidden = true

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
        collectionVC.collectionView = collectionView
        self.pushViewController(collectionVC, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photos = CoreDataManager.shared.getPhotos()
        collectionVC.collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - inset*2 - itemSpacing*3) / 4.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = GalleryDetailViewController()
        detailVC.imageName = photos[indexPath.row].name
        self.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
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
