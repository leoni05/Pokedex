//
//  GalleryCell.swift
//  Pokedex
//
//  Created by jyj on 7/27/25.
//

import Foundation
import UIKit
import PinLayout

class GalleryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "GalleryCell"
    private let containerView = UIView()
    private let imageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.layer.cornerRadius = 4.0
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        imageView.pin.all()
    }
}

// MARK: - Extensions

extension GalleryCell {
    func setImage(image: UIImage?) {
        imageView.image = image
    }
}
