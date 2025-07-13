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
    private var pokemonSet: Set<String> = []
    
    private var containerView = UIView()
    private var titleLabel = UILabel()
    private var numberLabel = UILabel()
    private var nameLabel = UILabel()
    private var pokemonImageView = UIImageView()
    private var prevButton = UIButton()
    private var nextButton = UIButton()
    private var selectedIndex: Int = 0
    
    private var failContainerView = UIView()
    private var failImageView = UIImageView()
    private var failLabel = UILabel()
    
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
        prevButton.addTarget(self, action: #selector(prevButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(prevButton)
        
        nextButton.setTitle("NEXT ▶", for: .normal)
        nextButton.setTitleColor(.wineRed, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(nextButton)
        
        self.view.addSubview(failContainerView)
        
        failImageView.image = UIImage(named: "pachirisu")
        failImageView.contentMode = .scaleAspectFill
        failImageView.layer.borderWidth = 1.0
        failImageView.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        failImageView.layer.cornerRadius = 25.0
        failImageView.layer.masksToBounds = true
        failContainerView.addSubview(failImageView)
        
        failLabel.textColor = .wineRed
        failLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        failLabel.text = "포켓몬을 찾지 못 했어요 ㅠ.ㅠ\n다시 시도해 볼까요?"
        failLabel.numberOfLines = 0
        failLabel.textAlignment = .center
        failContainerView.addSubview(failLabel)
        
        containerView.isHidden = true
        failContainerView.isHidden = true
        
        if resultPokemons.count >= 1 {
            containerView.isHidden = false
            showPokemon(index: selectedIndex)
        }
        else {
            failContainerView.isHidden = false
        }
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
        
        failImageView.pin.top().left().size(100)
        failLabel.pin.below(of: failImageView, aligned: .center).marginTop(12).sizeToFit()
        failContainerView.pin.center().wrapContent()
    }
    
}

// MARK: - Extensions

extension ResultViewController {
    func setResult(resultText: String) {
        let resultArray = resultText.components(separatedBy: ",")
        if resultArray.count > 0 {
            resultScore = Int(resultArray[0]) ?? 0
            resultPokemons = []
            pokemonSet = []
            
            for idx in 1..<resultArray.count {
                if Pokedex.shared.getPokemon(engName: resultArray[idx]) != nil
                    && pokemonSet.contains(resultArray[idx]) == false {
                    resultPokemons.append(resultArray[idx])
                    pokemonSet.insert(resultArray[idx])
                }
            }
        }
    }
}

// MARK: - Private Extensions

private extension ResultViewController {
    func showPokemon(index: Int) {
        if index == 0 { prevButton.isHidden = true }
        else { prevButton.isHidden = false }
        
        pokemonImageView.alpha = 0.0
        if let pokemon = Pokedex.shared.getPokemon(engName: resultPokemons[index]) {
            numberLabel.text = "No. \(String(format: "%04d", pokemon.pokedexNumber))"
            nameLabel.text = pokemon.name
            pokemonImageView.image = UIImage(named: "Pokedex\(String(format: "%03d", pokemon.pokedexNumber-1))")
            UIView.animate(withDuration: 0.4, animations: {
                self.pokemonImageView.alpha = 1.0
            })
        }
    }
    
    @objc func prevButtonPressed(_ sender: UIButton) {
        if selectedIndex == 0 { return }
        selectedIndex -= 1
        showPokemon(index: selectedIndex)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        if selectedIndex+1 >= resultPokemons.count { return }
        selectedIndex += 1
        showPokemon(index: selectedIndex)
    }
}
