//
//  PokedexDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 7/27/25.
//

import Foundation
import UIKit
import PinLayout

protocol PokedexDetailViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class PokedexDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: PokedexDetailViewControllerDelegate? = nil
    var engName: String = ""
    private var pokemon: PokemonModel? = nil
    
    private let scrollView = UIScrollView()
    private let numberLabel = UILabel()
    private let nameLabel = UILabel()
    private let pokeballImageView = UIImageView()
    private let pokemonImageContainerView = UIView()
    private let pokemonImageView = UIImageView()
    private let typeLabel1 = UILabel()
    private let typeLabel2 = UILabel()
    private let descLabel = UILabel()
    private let divView1 = UIView()
    private let categoryTitleLabel = UILabel()
    private let heightTitleLabel = UILabel()
    private let weightTitleLabel = UILabel()
    private let div2View2 = UIView()
    private let categoryLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    private let photoTitleLabel = UILabel()
    private let photoImageViews: [UIImageView] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        pokemon = Pokedex.shared.getPokemon(engName: engName)
        
        self.view.addSubview(scrollView)
        
        numberLabel.textColor = .wineRed
        numberLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        numberLabel.text = "No. \(String(format: "%04d", pokemon?.pokedexNumber ?? 0))"
        scrollView.addSubview(numberLabel)
        
        nameLabel.textColor = .wineRed
        nameLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        nameLabel.text = pokemon?.name
        scrollView.addSubview(nameLabel)
        
        pokeballImageView.image = UIImage(named: "pokeball.big.fill")
        pokeballImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(pokeballImageView)
        
        pokemonImageContainerView.layer.cornerRadius = 4.0
        pokemonImageContainerView.layer.borderWidth = 1.0
        pokemonImageContainerView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(pokemonImageContainerView)
        
        let pokedexNumber = pokemon?.pokedexNumber ?? 0
        pokemonImageView.image = UIImage(named: "Pokedex\(String(format: "%03d", pokedexNumber-1))")
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageContainerView.addSubview(pokemonImageView)
        
        typeLabel1.layer.cornerRadius = 4.0
        typeLabel1.layer.masksToBounds = true
        typeLabel1.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel1.text = "타입"
        typeLabel1.textColor = .white
        typeLabel1.textAlignment = .center
        scrollView.addSubview(typeLabel1)
        
        typeLabel2.layer.cornerRadius = 4.0
        typeLabel2.layer.masksToBounds = true
        typeLabel2.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel2.text = "타입"
        typeLabel2.textColor = .white
        typeLabel2.textAlignment = .center
        scrollView.addSubview(typeLabel2)
        
        typeLabel1.isHidden = true
        typeLabel2.isHidden = true
        if (pokemon?.type.count ?? 0) >= 1 {
            typeLabel1.text = pokemon?.type[0].rawValue
            typeLabel1.backgroundColor = pokemon?.type[0].color
            typeLabel1.isHidden = false
        }
        if (pokemon?.type.count ?? 0) >= 2 {
            typeLabel2.text = pokemon?.type[1].rawValue
            typeLabel2.backgroundColor = pokemon?.type[1].color
            typeLabel2.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        pokeballImageView.pin.top(MainUpperView.topInset + 16).right(16).size(32)
        numberLabel.pin.before(of: pokeballImageView, aligned: .top).left(16).marginRight(4).sizeToFit(.width)
        nameLabel.pin.below(of: numberLabel, aligned: .right).left(16).marginTop(4).sizeToFit(.width)
        pokemonImageContainerView.pin.below(of: nameLabel).horizontally(16).marginTop(16).height(274)
        pokemonImageView.pin.center().size(250)
        typeLabel1.pin.below(of: pokemonImageContainerView).left(16).width(52).height(22).marginTop(24)
        typeLabel2.pin.after(of: typeLabel1, aligned: .center).width(52).height(22).marginLeft(4)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.setBackButton(hidden: true)
    }

}
