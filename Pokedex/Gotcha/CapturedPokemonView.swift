//
//  CapturedPokemonView.swift
//  Pokedex
//
//  Created by jyj on 7/22/25.
//

import Foundation
import UIKit
import PinLayout

class CapturedPokemonView: UIView {
    
    // MARK: - Properties
    
    private var engName: String = ""
    private var imageView = UIImageView()
    private var numberLabel = UILabel()
    private var nameLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        numberLabel.textColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        numberLabel.font = UIFont(name: "Galmuri11-Bold", size: 12)
        numberLabel.text = "No. 0001"
        self.addSubview(numberLabel)
        
        nameLabel.textColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        nameLabel.font = UIFont(name: "Galmuri11-Bold", size: 16)
        nameLabel.text = "이상해씨"
        self.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.top(16).hCenter().size(112)
        nameLabel.pin.bottom(8).horizontally(16).sizeToFit(.width)
        numberLabel.pin.above(of: nameLabel).horizontally(16).marginBottom(4).sizeToFit(.width)
    }
    
}

extension CapturedPokemonView {
    func setPokemonInfo(engName: String) {
        guard let pokemon = Pokedex.shared.getPokemon(engName: engName) else { return }
        self.engName = engName
        imageView.image = UIImage(named: "Pokedex\(String(format: "%03d", pokemon.pokedexNumber-1))")
        numberLabel.text = "No. \(String(format: "%04d", pokemon.pokedexNumber))"
        nameLabel.text = pokemon.name
    }
}
