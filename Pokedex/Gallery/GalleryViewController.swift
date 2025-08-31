//
//  GalleryViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

protocol GalleryViewControllerDelegate: AnyObject {
    func setBackButtonForGallery(hidden: Bool)
}

class GalleryViewController: NavigationController {
    
    // MARK: - Properties

    weak var vcDelegate: GalleryViewControllerDelegate? = nil
    private var collectionVC = GalleryCollectionViewController()
    
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

// MARK: - GalleryDetailViewControllerDelegate

extension GalleryViewController: GalleryDetailViewControllerDelegate {
    func setBackButton(hidden: Bool) {
        vcDelegate?.setBackButtonForGallery(hidden: hidden)
    }
}
