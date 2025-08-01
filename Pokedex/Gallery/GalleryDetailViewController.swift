//
//  GalleryDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 8/1/25.
//

import Foundation
import UIKit
import PinLayout

class GalleryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
}
