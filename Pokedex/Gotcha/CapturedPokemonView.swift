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
    
    private var pokedexNumber: Int? = nil
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
    func setPokemonInfo(pokedexNumber: Int) {
        if pokedexNumber-1 >= Pokedex.shared.pokemons.count { return }
        let pokemon = Pokedex.shared.pokemons[pokedexNumber-1]
        setPokemonInfo(pokemon: pokemon)
    }
    
    func setPokemonInfo(pokemon: Pokemon) {
        let pokedexNumber = Int(pokemon.pokedexNumber)
        self.pokedexNumber = pokedexNumber
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let imageURL = documentsDirectory?.appendingPathComponent("\(pokedexNumber)", conformingTo: .png) {
            if FileManager.default.fileExists(atPath: imageURL.path) {
                imageView.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
        numberLabel.text = "No. \(String(format: "%04d", pokemon.pokedexNumber))"
        nameLabel.text = pokemon.name
    }
}
