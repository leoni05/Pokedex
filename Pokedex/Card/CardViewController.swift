//
//  CardViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

class CardViewController: UIViewController {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let trainerImage = UIImageView()
    
    private let infoView = UIView()
    private let nameLabel = UILabel()
    private let nameBottomLineView = UIView()
    private let pokedexLabel = UILabel()
    private let pokedexCountLabel = UILabel()
    private let scoreLabel = UILabel()
    private let scoreValueLabel = UILabel()
    private let levelLabel = UILabel()
    private let levelValueLabel = UILabel()
    
    private let selectionCount = 6
    private let selectedIndex: Array<Int> = [0, 1, 2, 84, 35, 32]
    private let selectionContainerView = UIView()
    private var selectionViews: Array<UIView> = []
    private var selectionImageViews: Array<UIImageView> = []
    
    private var badgesLabel = UILabel()
    private let badgeCount = 8
    private let badgeContainerView = UIView()
    private var badgeViews: Array<UIView> = []
    private var badgeImageViews: Array<UIImageView> = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        
        titleLabel.text = "TRAINER CARD"
        titleLabel.textColor = .wineRed
        titleLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        titleLabel.layer.borderColor = UIColor.wineRed.cgColor
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.cornerRadius = 4.0
        titleLabel.textAlignment = .center
        scrollView.addSubview(titleLabel)
        
        trainerImage.image = UIImage(named: "TrainerCard19")
        trainerImage.contentMode = .scaleAspectFill
        trainerImage.layer.cornerRadius = 4.0
        trainerImage.layer.borderWidth = 1.0
        trainerImage.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(trainerImage)
        
        scrollView.addSubview(infoView)
        
        nameLabel.text = "이름: 빛나"
        nameLabel.textColor = .wineRed
        nameLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        nameLabel.numberOfLines = 1
        infoView.addSubview(nameLabel)
        
        nameBottomLineView.backgroundColor = .wineRed
        infoView.addSubview(nameBottomLineView)
        
        pokedexLabel.text = "포켓몬 도감"
        pokedexLabel.textColor = .wineRed
        pokedexLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        infoView.addSubview(pokedexLabel)
        
        pokedexCountLabel.text = "12"
        pokedexCountLabel.textColor = .wineRed
        pokedexCountLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        pokedexCountLabel.textAlignment = .right
        pokedexCountLabel.numberOfLines = 1
        infoView.addSubview(pokedexCountLabel)
        
        scoreLabel.text = "스코어"
        scoreLabel.textColor = .wineRed
        scoreLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        infoView.addSubview(scoreLabel)
        
        scoreValueLabel.text = "311234"
        scoreValueLabel.textColor = .wineRed
        scoreValueLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        scoreValueLabel.textAlignment = .right
        scoreValueLabel.numberOfLines = 1
        infoView.addSubview(scoreValueLabel)
        
        levelLabel.text = "트레이너 레벨"
        levelLabel.textColor = .wineRed
        levelLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        infoView.addSubview(levelLabel)
        
        levelValueLabel.text = "Lv 4"
        levelValueLabel.textColor = .wineRed
        levelValueLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        levelValueLabel.textAlignment = .right
        levelValueLabel.numberOfLines = 1
        infoView.addSubview(levelValueLabel)
        
        scrollView.addSubview(selectionContainerView)
        
        for idx in 0..<selectionCount {
            let view = UIView()
            view.layer.cornerRadius = 4.0
            view.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            view.layer.borderWidth = 1.0
            selectionContainerView.addSubview(view)
            selectionViews.append(view)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if idx < selectedIndex.count {
                imageView.image = UIImage(named: "Pokedex" + String(format: "%03d", selectedIndex[idx]))
            }
            view.addSubview(imageView)
            selectionImageViews.append(imageView)
        }
        
        badgesLabel.text = "BADGES"
        badgesLabel.textColor = .wineRed
        badgesLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        badgesLabel.numberOfLines = 1
        scrollView.addSubview(badgesLabel)
        
        scrollView.addSubview(badgeContainerView)
        
        for idx in 0..<badgeCount {
            let view = UIView()
            view.layer.cornerRadius = 4.0
            view.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            view.layer.borderWidth = 1.0
            badgeContainerView.addSubview(view)
            badgeViews.append(view)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Badge\(idx)")
            view.addSubview(imageView)
            badgeImageViews.append(imageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        titleLabel.pin.top(16 + MainUpperView.topInset).left(16).width(128).height(27)
        trainerImage.pin.below(of: titleLabel).right(16).width(112).height(120).marginTop(24)
        
        infoView.pin.before(of: trainerImage, aligned: .top).left(16).height(120).marginRight(32)
        nameLabel.pin.top().horizontally().sizeToFit(.width)
        nameBottomLineView.pin.below(of: nameLabel, aligned: .right).left().height(1).marginTop(4)
        pokedexLabel.pin.bottom().left().sizeToFit()
        pokedexCountLabel.pin.after(of: pokedexLabel, aligned: .bottom).right().marginLeft(8).sizeToFit(.width)
        scoreLabel.pin.above(of: pokedexLabel, aligned: .left).marginBottom(12).sizeToFit()
        scoreValueLabel.pin.after(of: scoreLabel, aligned: .bottom).right().marginLeft(8).sizeToFit(.width)
        levelLabel.pin.above(of: scoreLabel, aligned: .left).marginBottom(12).sizeToFit()
        levelValueLabel.pin.after(of: levelLabel, aligned: .bottom).right().marginLeft(8).sizeToFit(.width)
        
        selectionContainerView.pin.below(of: infoView).horizontally(16).marginTop(24)
        let pokemonSize = (selectionContainerView.frame.width - (8.0*2))/3.0
        selectionViews[0].pin.top().left().size(pokemonSize)
        selectionViews[1].pin.top().hCenter().size(pokemonSize)
        selectionViews[2].pin.top().right().size(pokemonSize)
        selectionViews[3].pin.below(of: selectionViews[0], aligned: .left).marginTop(8).size(pokemonSize)
        selectionViews[4].pin.below(of: selectionViews[1], aligned: .center).marginTop(8).size(pokemonSize)
        selectionViews[5].pin.below(of: selectionViews[2], aligned: .right).marginTop(8).size(pokemonSize)
        selectionContainerView.pin.below(of: infoView).hCenter().marginTop(24).wrapContent()
        
        for idx in 0..<selectionImageViews.count {
            selectionImageViews[idx].pin.all(12)
        }
        
        badgesLabel.pin.below(of: selectionContainerView).horizontally(16).marginTop(32).sizeToFit(.width)
        badgeContainerView.pin.below(of: badgesLabel).horizontally(16).marginTop(12)
        let badgeSize = (badgeContainerView.frame.width - (8.0*3))/4.0
        badgeViews[0].pin.top().left().size(badgeSize)
        badgeViews[1].pin.after(of: badgeViews[0], aligned: .top).marginLeft(8).size(badgeSize)
        badgeViews[3].pin.top().right().size(badgeSize)
        badgeViews[2].pin.before(of: badgeViews[3], aligned: .top).marginRight(8).size(badgeSize)
        badgeViews[4].pin.below(of: badgeViews[0], aligned: .left).marginTop(8).size(badgeSize)
        badgeViews[5].pin.below(of: badgeViews[1], aligned: .left).marginTop(8).size(badgeSize)
        badgeViews[6].pin.below(of: badgeViews[2], aligned: .left).marginTop(8).size(badgeSize)
        badgeViews[7].pin.below(of: badgeViews[3], aligned: .left).marginTop(8).size(badgeSize)
        badgeContainerView.pin.below(of: badgesLabel).hCenter().marginTop(12).wrapContent()
        
        for idx in 0..<badgeImageViews.count {
            badgeImageViews[idx].pin.all(12)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width,
                                        height: badgeContainerView.frame.maxY + 24)
    }
    
}
