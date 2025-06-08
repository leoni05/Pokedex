//
//  PokedexHeader.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation
import UIKit
import PinLayout

class PokedexHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "PokedexHeader"
    private let progressLabel = UILabel()
    private let pokedexNameLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        progressLabel.text = "도감 완성률 12%"
        progressLabel.textColor = .wineRed
        progressLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        progressLabel.numberOfLines = 1
        self.addSubview(progressLabel)
        
        pokedexNameLabel.text = "신오 지방 도감"
        pokedexNameLabel.textColor = .wineRed
        pokedexNameLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        pokedexNameLabel.numberOfLines = 1
        self.addSubview(pokedexNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pokedexNameLabel.pin.bottom().horizontally(16).sizeToFit(.width)
        progressLabel.pin.above(of: pokedexNameLabel, aligned: .left).right(16).marginBottom(8).sizeToFit(.width)
    }
}
