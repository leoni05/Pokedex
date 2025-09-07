//
//  CardPokemonCell.swift
//  Pokedex
//
//  Created by jyj on 9/7/25.
//

import Foundation
import UIKit
import PinLayout

protocol CardPokemonCellDelegate: AnyObject {
    func cellPressed(idx: Int)
}

class CardPokemonCell: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CardPokemonCellDelegate? = nil
    private let containerView = UIView()
    private let pokemonImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.layer.cornerRadius = 4.0
        containerView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        containerView.layer.borderWidth = 1.0
        self.addSubview(containerView)
        
        pokemonImageView.contentMode = .center
        pokemonImageView.image = UIImage(named: "pokeball.small")
        containerView.addSubview(pokemonImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellPressed(_:)))
        self.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.delegate = self
        longPressGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        pokemonImageView.pin.all(12)
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension CardPokemonCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func cellPressed(_ sender: UITapGestureRecognizer) {
        if let idx = sender.view?.tag {
            delegate?.cellPressed(idx: idx)
        }
    }
    
    @objc func cellLongPressed(_ gesture: UILongPressGestureRecognizer) {
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
