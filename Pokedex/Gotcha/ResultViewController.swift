//
//  ResultViewController.swift
//  Pokedex
//
//  Created by jyj on 7/12/25.
//

import Foundation
import UIKit
import PinLayout

protocol ResultViewControllerDelegate: AnyObject {
    func resultOkButtonPressed()
}

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    var gotchaResult: GotchaResult? = nil
    
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
    
    private var summaryScrollView = UIScrollView()
    private var summaryTitleLabel = UILabel()
    private var summaryStarsLabel = UILabel()
    private var summaryXpLabel = UILabel()
    private var summaryLevelLabel = UILabel()
    private var summaryXpBarView = SummaryXpBarView()
    private var summaryCapturedPokemonsLabel = UILabel()
    private var summaryPokemonsWrapper = UIView()
    private var summaryCapturedPokemonViews: Array<CapturedPokemonView> = []
    
    private var okButton = UIButton()
    weak var delegate: ResultViewControllerDelegate? = nil
    
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
        
        self.view.addSubview(summaryScrollView)
        
        summaryTitleLabel.textColor = .wineRed
        summaryTitleLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        summaryTitleLabel.text = "획득 경험치"
        summaryScrollView.addSubview(summaryTitleLabel)
        
        var starArray: [Character] = ["☆", "☆", "☆", "☆", "☆"]
        let resultScore = gotchaResult?.resultScore ?? 0
        for idx in 0..<starArray.count {
            if idx * 100 < resultScore {
                starArray[idx] = "★"
            }
        }
        summaryStarsLabel.textColor = .wineRed
        summaryStarsLabel.font = UIFont(name: "Galmuri11-Bold", size: 40)
        summaryStarsLabel.text = String(starArray)
        summaryScrollView.addSubview(summaryStarsLabel)
        
        summaryXpLabel.textColor = .wineRed
        summaryXpLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        summaryXpLabel.text = "\(resultScore)xp"
        summaryXpLabel.textAlignment = .right
        summaryScrollView.addSubview(summaryXpLabel)
        
        summaryLevelLabel.textColor = .wineRed
        summaryLevelLabel.font = UIFont(name: "Galmuri11-Bold", size: 16)
        summaryLevelLabel.text = "Lv \(Pokedex.shared.trainerLevel)"
        summaryScrollView.addSubview(summaryLevelLabel)
        
        summaryXpBarView.percentVal = Pokedex.shared.nextRequiredScorePercent
        summaryScrollView.addSubview(summaryXpBarView)
        
        summaryCapturedPokemonsLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        summaryCapturedPokemonsLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        summaryCapturedPokemonsLabel.text = "잡은 포켓몬"
        summaryScrollView.addSubview(summaryCapturedPokemonsLabel)
        
        summaryScrollView.addSubview(summaryPokemonsWrapper)
        
        if let gotchaResult = gotchaResult {
            for idx in 0..<gotchaResult.resultPokemonNumbers.count {
                let view = CapturedPokemonView()
                view.setPokemonInfo(pokedexNumber: gotchaResult.resultPokemonNumbers[idx])
                summaryCapturedPokemonViews.append(view)
                summaryPokemonsWrapper.addSubview(view)
            }
        }
        
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = UIColor.wineRed.cgColor
        okButton.backgroundColor = .white
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.wineRed, for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        okButton.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(okButton)
        
        okButton.isHidden = true
        containerView.isHidden = true
        failContainerView.isHidden = true
        summaryScrollView.isHidden = true
        
        if let gotchaResult = gotchaResult,
           gotchaResult.resultPokemonNumbers.count >= 1 {
            containerView.isHidden = false
            showPokemon(index: selectedIndex)
        }
        else {
            failContainerView.isHidden = false
            okButton.isHidden = false
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
        
        summaryScrollView.pin.all()
        summaryTitleLabel.pin.top(MainUpperView.topInset + 16).horizontally(16).sizeToFit(.width)
        summaryStarsLabel.pin.below(of: summaryTitleLabel, aligned: .left).marginTop(8).sizeToFit()
        summaryXpLabel.pin.after(of: summaryStarsLabel, aligned: .center).right(16).marginLeft(8).sizeToFit(.width)
        summaryLevelLabel.pin.below(of: summaryStarsLabel).horizontally(16).marginTop(24).sizeToFit(.width)
        summaryXpBarView.pin.below(of: summaryLevelLabel).horizontally(16).marginTop(4).height(21)
        summaryCapturedPokemonsLabel.pin.below(of: summaryXpBarView).marginTop(40).horizontally(16).sizeToFit(.width)
        summaryPokemonsWrapper.pin.below(of: summaryCapturedPokemonsLabel).horizontally(16).marginTop(12)
        for idx in 0..<summaryCapturedPokemonViews.count {
            let view = summaryCapturedPokemonViews[idx]
            let gap: CGFloat = 12.0
            let width: CGFloat = (summaryPokemonsWrapper.frame.width-gap)/2.0
            let height: CGFloat = 201.0
            let x: CGFloat = ((idx%2==0) ? 0.0 : width+gap)
            let y = CGFloat(idx/2) * (height+gap)
            view.pin.left(x).top(y).width(width).height(height)
        }
        summaryPokemonsWrapper.pin.below(of: summaryCapturedPokemonsLabel).left(16).wrapContent().marginTop(12)
        summaryScrollView.contentSize = CGSize(width: summaryScrollView.bounds.width,
                                               height: summaryPokemonsWrapper.frame.maxY + 16)
        
        okButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
}

// MARK: - Private Extensions

private extension ResultViewController {
    func showPokemon(index: Int) {
        guard let gotchaResult = gotchaResult else { return }
        
        if index == 0 { prevButton.isHidden = true }
        else { prevButton.isHidden = false }
        
        pokemonImageView.alpha = 0.0
        let pokemon = Pokedex.shared.pokemons[gotchaResult.resultPokemonNumbers[index]-1]
        numberLabel.text = "No. \(String(format: "%04d", pokemon.pokedexNumber))"
        nameLabel.text = pokemon.name
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let imageURL = documentsDirectory?.appendingPathComponent("\(pokemon.pokedexNumber)", conformingTo: .png) {
            if FileManager.default.fileExists(atPath: imageURL.path) {
                pokemonImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.pokemonImageView.alpha = 1.0
        })
    }
    
    func showSummary() {
        containerView.isHidden = true
        summaryScrollView.isHidden = false
        okButton.isHidden = false
    }
    
    @objc func prevButtonPressed(_ sender: UIButton) {
        if selectedIndex == 0 { return }
        selectedIndex -= 1
        showPokemon(index: selectedIndex)
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        guard let gotchaResult = gotchaResult else { return }
        if selectedIndex+1 >= gotchaResult.resultPokemonNumbers.count {
            showSummary()
            return
        }
        selectedIndex += 1
        showPokemon(index: selectedIndex)
    }
    
    @objc func okButtonPressed(_ sender: UIButton) {
        delegate?.resultOkButtonPressed()
    }
}
