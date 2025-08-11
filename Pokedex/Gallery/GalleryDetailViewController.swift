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
    
    private let scrollView = UIScrollView()
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
        
        self.view.addSubview(scrollView)
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let imageName = imageName {
            let fileUrl = documentsDirectory.appendingPathComponent(imageName, conformingTo: .jpeg)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                imageView.image = UIImage(contentsOfFile: fileUrl.path)
            }
        }
        imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        imageView.pin.top(MainUpperView.topInset + 32).horizontally().aspectRatio()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: imageView.frame.maxY + 12)
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
