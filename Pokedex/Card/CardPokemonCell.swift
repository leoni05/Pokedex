//
//  CardPokemonCell.swift
//  Pokedex
//
//  Created by jyj on 9/7/25.
//

import Foundation
import UIKit
import PinLayout

class CardPokemonCell: UIView {
    
    // MARK: - Properties
    
    private let pokemonImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        self.layer.borderWidth = 1.0
        
        pokemonImageView.contentMode = .center
        pokemonImageView.image = UIImage(named: "pokeball.small")
        self.addSubview(pokemonImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pokemonImageView.pin.all(12)
    }
    
}
