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
        
        xpTitleLabel.text = "획득 경험치"
        xpTitleLabel.textColor = .wineRed
        xpTitleLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        scrollView.addSubview(xpTitleLabel)
        
        downloadButton.setImage(UIImage(named: "download"), for: .normal)
        scrollView.addSubview(downloadButton)
        
        starsLabel.text = "★★★☆☆"
        starsLabel.textColor = .wineRed
        starsLabel.font = UIFont(name: "Galmuri11-Bold", size: 40)
        scrollView.addSubview(starsLabel)
        
        xpLabel.text = "450xp"
        xpLabel.textColor = .wineRed
        xpLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        xpLabel.textAlignment = .right
        scrollView.addSubview(xpLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        imageView.pin.top(MainUpperView.topInset + 32).horizontally().aspectRatio()
        xpTitleLabel.pin.below(of: imageView).left(16).marginTop(20).sizeToFit()
        downloadButton.pin.vCenter(to: xpTitleLabel.edge.vCenter).right(16).size(40)
        starsLabel.pin.below(of: xpTitleLabel).left(16).marginTop(8).sizeToFit()
        xpLabel.pin.after(of: starsLabel, aligned: .center).right(16).marginLeft(8).sizeToFit(.width)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: starsLabel.frame.maxY + 12)
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
