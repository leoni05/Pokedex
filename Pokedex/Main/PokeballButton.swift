//
//  PokeballButton.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation
import UIKit
import PinLayout

class PokeballButton: UIButton {
    
    // MARK: - Properties
    
    let tabType: TabType? = .camera
    private let pokeballImageName = "tab.pokeball"
    private let containerView = UIView()
    private let btnImageView = UIImageView()
    private let btnFillImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        containerView.isUserInteractionEnabled = false
        addSubview(containerView)
        
        btnImageView.image = UIImage(named: pokeballImageName)
        btnImageView.contentMode = .scaleAspectFit
        containerView.addSubview(btnImageView)
        
        btnFillImageView.image = UIImage(named: pokeballImageName + ".fill")
        btnFillImageView.contentMode = .scaleAspectFit
        btnFillImageView.alpha = 0.0
        containerView.addSubview(btnFillImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        btnImageView.pin.all()
        btnFillImageView.pin.all()
    }
    
}

// MARK: - Extensions

extension PokeballButton {
    func setStatus(activated: Bool) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 4
        rotationAnimation.duration = 0.6
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        containerView.layer.add(rotationAnimation, forKey: nil)
        
        UIView.animate(withDuration: 0.6) {
            self.btnImageView.alpha = (activated ? 0.0 : 1.0)
            self.btnFillImageView.alpha = (activated ? 1.0 : 0.0)
        }
    }
}
