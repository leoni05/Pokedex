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
    private let btnImageView = UIImageView()
    
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
        btnImageView.image = UIImage(named: pokeballImageName)
        btnImageView.contentMode = .scaleAspectFit
        addSubview(btnImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btnImageView.pin.all()
    }
    
}

// MARK: - Extensions

extension PokeballButton {
    func setStatus(activated: Bool) {
        let imageName = pokeballImageName + (activated ? ".fill" : "")
        btnImageView.image = UIImage(named: imageName)
    }
}
