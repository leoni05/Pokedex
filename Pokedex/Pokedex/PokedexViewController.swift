//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

class PokedexViewController: NavigationController {
    
    // MARK: - Properties

    private let horizontalInset = 16.0
    private let itemSpacing = 12.0
    private let itemHeight: CGFloat = 253.0
    private var collectionVC = UICollectionViewController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.headerReferenceSize = CGSize(width: 0.0, height: 68.0 + MainUpperView.topInset)
        layout.sectionInset = UIEdgeInsets(top: 24.0, left: horizontalInset,
                                           bottom: 16.0, right: horizontalInset)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.reuseIdentifier)
        collectionView.register(PokedexHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PokedexHeader.reuseIdentifier)
        collectionVC.collectionView = collectionView
        self.pushViewController(collectionVC, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PokedexViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - horizontalInset*2 - itemSpacing) / 2.0
        return CGSize(width: width, height: itemHeight)
    }
}

// MARK: - UICollectionViewDataSource

extension PokedexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pokedex.shared.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.reuseIdentifier, for: indexPath)
        if let cell = reusableCell as? PokedexCell {
            cell.setPokemonInfo(index: indexPath.row)
        }
        return reusableCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PokedexHeader.reuseIdentifier, for: indexPath)
            if let header = reusableView as? PokedexHeader {
                
            }
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PokedexDetailViewController()
        self.pushViewController(detailVC, animated: true)
    }
}
