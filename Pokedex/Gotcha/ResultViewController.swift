//
//  ResultViewController.swift
//  Pokedex
//
//  Created by jyj on 7/12/25.
//

import Foundation
import UIKit
import PinLayout

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private var resultScore: Int = 0
    private var resultPokemons: Array<String> = []
    
    private var containerView = UIView()
    private var titleLabel = UILabel()
    private var numberLabel = UILabel()
    private var nameLabel = UILabel()
    private var pokemonImageView = UIImageView()
    private var prevButton = UIButton()
    private var nextButton = UIButton()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        
        titleLabel.textColor = .wineRed
        titleLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        titleLabel.text = "포켓몬을 잡았다!"
        containerView.addSubview(titleLabel)
        
        numberLabel.textColor = .wineRed
        numberLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        numberLabel.text = "No. 0094"
        containerView.addSubview(numberLabel)
        
        nameLabel.textColor = .wineRed
        nameLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        nameLabel.text = "팬텀"
        containerView.addSubview(nameLabel)
        
        pokemonImageView.image = UIImage(named: "Pokedex000")
        pokemonImageView.contentMode = .scaleAspectFit
        containerView.addSubview(pokemonImageView)
        
        prevButton.setTitle("◀ PREV", for: .normal)
        prevButton.setTitleColor(.wineRed, for: .normal)
        prevButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        containerView.addSubview(prevButton)
        
        nextButton.setTitle("NEXT ▶", for: .normal)
        nextButton.setTitleColor(.wineRed, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        containerView.addSubview(nextButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.pin.top(MainUpperView.topInset).horizontally().bottom()
        titleLabel.pin.top(16).horizontally(16).sizeToFit(.width)
        numberLabel.pin.below(of: titleLabel).horizontally(16).marginTop(24).sizeToFit(.width)
        nameLabel.pin.below(of: numberLabel).horizontally(16).marginTop(4).sizeToFit(.width)
        
        prevButton.pin.bottom(40).left(16).sizeToFit()
        nextButton.pin.bottom(40).right(16).sizeToFit()
        pokemonImageView.pin.center().size(250)
    }
    
}

// MARK: - Extensions

extension ResultViewController {
    func setResult(resultText: String) {
        let resultArray = resultText.components(separatedBy: ",")
        if resultArray.count > 0 {
            resultScore = Int(resultArray[0]) ?? 0
            resultPokemons = []
            for idx in 1..<resultArray.count {
                if Pokedex.shared.getPokemon(engName: resultArray[idx]) != nil {
                    resultPokemons.append(resultArray[idx])
                }
            }
        }
    }
}
