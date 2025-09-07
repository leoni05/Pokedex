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
    private let animationMaxDelay: Double = 0.54
    private let animationDuration: Double = 0.46
    
    private let failContainerView = UIView()
    private let failImageView = UIImageView()
    private let failLabel = UILabel()
    private let failReloadButton = UIButton()
    
    private let inset = 16.0
    private let itemSpacing = 4.0
    private var photos: [Photo] = []
    private var isAnimating = false
    
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
        
        self.view.addSubview(failContainerView)
        
        failImageView.image = UIImage(named: "pachirisu")
        failImageView.contentMode = .scaleAspectFill
        failImageView.layer.borderWidth = 1.0
        failImageView.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        failImageView.layer.cornerRadius = 25.0
        failImageView.layer.masksToBounds = true
        failContainerView.addSubview(failImageView)
        
        failLabel.textColor = .wineRed
        failLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        failLabel.text = "사진이 없어요 ㅠ.ㅠ\n사진을 찍어 포켓몬을 잡아보세요."
        failLabel.numberOfLines = 0
        failLabel.textAlignment = .center
        failContainerView.addSubview(failLabel)
        
        failReloadButton.layer.borderWidth = 2.0
        failReloadButton.layer.borderColor = UIColor.wineRed.cgColor
        failReloadButton.backgroundColor = .white
        failReloadButton.setTitle("확인", for: .normal)
        failReloadButton.setTitleColor(.wineRed, for: .normal)
        failReloadButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        failReloadButton.addTarget(self, action: #selector(failReloadButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(failReloadButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.pin.all()
        collectionView?.pin.all()
        
        failImageView.pin.top().left().size(100)
        failLabel.pin.below(of: failImageView, aligned: .center).marginTop(12).sizeToFit()
        failContainerView.pin.center().wrapContent()
        failReloadButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (collectionView?.contentOffset.y ?? 0) < 0 {
            collectionView?.setContentOffset(.zero, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CoreDataManager.shared.needReloadGalleryVC {
            CoreDataManager.shared.needReloadGalleryVC = false
            reloadPhotosFirstTime()
        }
    }
    
}

// MARK: - Extensions

extension GalleryCollectionViewController {
    func reloadPhotosFirstTime() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        collectionView?.isHidden = true
        failContainerView.isHidden = true
        failReloadButton.isHidden = true
        failContainerView.alpha = 0.0
        failReloadButton.alpha = 0.0
        
        DispatchQueue.main.async {
            self.photos = CoreDataManager.shared.getPhotos()
            
            if self.photos.count == 0 {
                self.failContainerView.isHidden = false
                self.failReloadButton.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.failContainerView.alpha = 1.0
                    self.failReloadButton.alpha = 1.0
                }
            }
            else {
                self.isAnimating = true
                self.collectionView?.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration + self.animationMaxDelay) {
                    self.isAnimating = false
                    self.collectionView?.isUserInteractionEnabled = true
                }
                
                self.collectionView?.reloadData()
                self.collectionView?.isHidden = false
            }
            
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
        }
    }
}

// MARK: - Private Extensions

private extension GalleryCollectionViewController {
    @objc func handleRefreshControl() {
        self.photos = CoreDataManager.shared.getPhotos()
        
        if photos.count == 0 {
            self.failContainerView.alpha = 0.0
            self.failReloadButton.alpha = 0.0
            self.failContainerView.isHidden = false
            self.failReloadButton.isHidden = false
            self.collectionView?.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.failContainerView.alpha = 1.0
                self.failReloadButton.alpha = 1.0
            }
        }
        else {
            self.collectionView?.reloadData()
        }
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    @objc func failReloadButtonPressed(_ sender: UIButton) {
        reloadPhotosFirstTime()
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
        detailVC.photo = photos[indexPath.row]
        detailVC.delegate = navigationController as? GalleryDetailViewControllerDelegate
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? GalleryCell else { return }
        if isAnimating {
            let x = indexPath.row % 4
            let y = indexPath.row / 4
            let delay: TimeInterval = min(Double(y+x)/12.0 * animationMaxDelay, animationMaxDelay)
            cell.setAnimationForAlpha(duration: animationDuration, delay: delay)
        }
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
