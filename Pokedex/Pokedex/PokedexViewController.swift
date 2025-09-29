//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

protocol PokedexViewControllerDelegate: AnyObject {
    func setBackButtonForPokedex()
}

class PokedexViewController: NavigationController {
    
    // MARK: - Properties

    weak var vcDelegate: PokedexViewControllerDelegate? = nil
    private var collectionVC = PokedexCollectionViewController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isNavigationBarHidden = true
        self.pushViewController(collectionVC, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.popToRootViewController(animated: false)
    }
    
}

// MARK: - PokedexDetailViewControllerDelegate

extension PokedexViewController: PokedexDetailViewControllerDelegate {
    func setBackButton() {
        vcDelegate?.setBackButtonForPokedex()
    }
}

// MARK: - PokedexPhotoViewControllerDelegate

extension PokedexViewController: PokedexPhotoViewControllerDelegate {
    func setBackButtonForPhoto() {
        vcDelegate?.setBackButtonForPokedex()
    }
}
