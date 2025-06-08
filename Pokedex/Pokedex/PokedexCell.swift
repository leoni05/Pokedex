//
//  PokedexCell.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation
import UIKit
import PinLayout

class PokedexCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "PokedexCell"
    private var containerView = UIView()
    private var pokedexIndex: Int? = nil
    private var indexLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 4.0
        self.addSubview(containerView)
        
        indexLabel.font = UIFont(name: "Galmuri11-Bold", size: 12)
        indexLabel.textColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.addSubview(indexLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        indexLabel.pin.center().sizeToFit()
    }
    
}

// MARK: - Extensions

extension PokedexCell {
    func setPokemonInfo(index: Int) {
        pokedexIndex = index
        indexLabel.text = "No. \(String(format: "%04d", index+1))"
    }
}
