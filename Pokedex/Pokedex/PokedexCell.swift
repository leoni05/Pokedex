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
    private let pokeballImageName = "pokeball.small"
    private var pokeballImageView = UIImageView()
    private var pokemonImageView = UIImageView()
    private var captureDateLabel = UILabel()
    private var typeLabel1 = UILabel()
    private var typeLabel2 = UILabel()
    private var nameLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 4.0
        self.addSubview(containerView)
        
        pokeballImageView.image = UIImage(named: pokeballImageName)
        pokeballImageView.contentMode = .scaleAspectFit
        containerView.addSubview(pokeballImageView)
        
        pokemonImageView.image = UIImage(named: "Pokedex000")
        pokemonImageView.contentMode = .scaleAspectFit
        containerView.addSubview(pokemonImageView)
        
        captureDateLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        captureDateLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        captureDateLabel.numberOfLines = 1
        captureDateLabel.text = "미포획"
        containerView.addSubview(captureDateLabel)
        
        typeLabel1.layer.cornerRadius = 4.0
        typeLabel1.layer.masksToBounds = true
        typeLabel1.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel1.text = "타입"
        typeLabel1.textColor = .white
        typeLabel1.textAlignment = .center
        containerView.addSubview(typeLabel1)
        
        typeLabel2.layer.cornerRadius = 4.0
        typeLabel2.layer.masksToBounds = true
        typeLabel2.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel2.text = "타입"
        typeLabel2.textColor = .white
        typeLabel2.textAlignment = .center
        containerView.addSubview(typeLabel2)
        
        nameLabel.font = UIFont(name: "Galmuri11-Bold", size: 16)
        nameLabel.textColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        nameLabel.numberOfLines = 1
        containerView.addSubview(nameLabel)
        
        indexLabel.font = UIFont(name: "Galmuri11-Bold", size: 12)
        indexLabel.textColor = UIColor(red: 42.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        indexLabel.numberOfLines = 1
        containerView.addSubview(indexLabel)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellContentsLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.delegate = self
        longPressGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        pokeballImageView.pin.top(8).right(8).size(24)
        pokemonImageView.pin.top(16).hCenter().size(112)
        captureDateLabel.pin.bottom(8).horizontally(16).sizeToFit(.width)
        typeLabel1.pin.above(of: captureDateLabel, aligned: .left).width(52).height(22).marginBottom(8)
        typeLabel2.pin.after(of: typeLabel1, aligned: .center).width(52).height(22).marginLeft(4)
        nameLabel.pin.above(of: typeLabel1, aligned: .left).right(16).marginBottom(8).sizeToFit(.width)
        indexLabel.pin.above(of: nameLabel, aligned: .left).right(16).marginBottom(4).sizeToFit(.width)
    }
    
}

// MARK: - Extensions

extension PokedexCell {
    func setPokemonInfo(index: Int) {
        pokedexIndex = index
        
        setPokemonImage(index: index)
        setCaptureDateLabel(captureDate: Pokedex.shared.pokemons[index].captureDate)
        setTypeLabels(typeString: Pokedex.shared.pokemons[index].type)
        nameLabel.text = Pokedex.shared.pokemons[index].name
        indexLabel.text = "No. \(String(format: "%04d", index+1))"
    }
}

// MARK: - Private Extensions

private extension PokedexCell {
    func setPokemonImage(index: Int) {
        let pokeballImageNameSuffix = ((Pokedex.shared.pokemons[index].captureDate != nil) ? ".fill" : "")
        pokeballImageView.image = UIImage(named: pokeballImageName + pokeballImageNameSuffix)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let imageURL = documentsDirectory?.appendingPathComponent("\(index+1)", conformingTo: .png) {
            if FileManager.default.fileExists(atPath: imageURL.path) {
                pokemonImageView.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
    }
    
    func setCaptureDateLabel(captureDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        captureDateLabel.text = "미포획"
        if let captureDate = captureDate {
            captureDateLabel.text = dateFormatter.string(for: captureDate)
        }
    }
    
    func setTypeLabels(typeString: String?) {
        typeLabel1.isHidden = true
        typeLabel2.isHidden = true
        
        guard let types = typeString?.components(separatedBy: ",") else { return }
        
        if types.count >= 1 {
            let pokemonType = PokemonType(rawValue: types[0])
            typeLabel1.text = pokemonType?.koreanText
            typeLabel1.backgroundColor = pokemonType?.color
            typeLabel1.isHidden = false
        }
        if types.count >= 2 {
            let pokemonType = PokemonType(rawValue: types[1])
            typeLabel2.text = pokemonType?.koreanText
            typeLabel2.backgroundColor = pokemonType?.color
            typeLabel2.isHidden = false
        }
    }
    
    @objc func cellContentsLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.containerView.backgroundColor = .systemGray6
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97)
            }
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = .clear
            self.containerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PokedexCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
