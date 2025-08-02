//
//  GalleryDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 8/1/25.
//

import Foundation
import UIKit
import PinLayout

protocol GalleryDetailViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class GalleryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GalleryDetailViewControllerDelegate? = nil
    
    var imageName: String?
    
    private let imageView = UIImageView()
    private let xpTitleLabel = UILabel()
    private let starsLabel = UILabel()
    private let downloadButton = UIButton()
    private let xpLabel = UILabel()
    private let capturedPokemonsLabel = UILabel()
    private let pokemonContaierView = UIView()
    private let pokemonImageViews: [UIImageView] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.setBackButton(hidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.setBackButton(hidden: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.setBackButton(hidden: true)
    }
    
}
