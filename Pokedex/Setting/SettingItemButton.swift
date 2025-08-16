//
//  SettingItemButton.swift
//  Pokedex
//
//  Created by jyj on 7/26/25.
//

import Foundation
import UIKit
import PinLayout

class SettingItemButton: UIButton {
    
    // MARK: - Properties
    
    private let containerView = UIView()
    private let btnImageView = UIImageView()
    private let btnLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.layer.cornerRadius = 4.0
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        
        btnImageView.image = UIImage(named: "pokeball.small.fill")
        btnImageView.contentMode = .scaleAspectFit
        containerView.addSubview(btnImageView)
        
        btnLabel.text = "Setting Item"
        btnLabel.textColor = .wineRed
        btnLabel.font = UIFont(name: "Galmuri11-Regular", size: 16)
        containerView.addSubview(btnLabel)
        
        containerView.isUserInteractionEnabled = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(contentsLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        containerView.pin.all()
        btnImageView.pin.left().vCenter().size(24)
        btnLabel.pin.after(of: btnImageView, aligned: .center).right().marginLeft(16).sizeToFit(.width)
    }
    
}

// MARK: - Extensions

extension SettingItemButton {
    func setText(text: String) {
        btnLabel.text = text
    }
}

// MARK: - Private Extensions

private extension SettingItemButton {
    @objc func contentsLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.containerView.backgroundColor = .systemGray6
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97)
            }
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = .clear
            self.containerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
}
