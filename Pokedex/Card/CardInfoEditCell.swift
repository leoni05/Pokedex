//
//  CardInfoEditCell.swift
//  Pokedex
//
//  Created by jyj on 8/16/25.
//

import Foundation
import UIKit
import PinLayout

protocol CardInfoEditCellDelegate: AnyObject {
    func cellPressed(idx: Int)
}

class CardInfoEditCell: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CardInfoEditCellDelegate? = nil
    
    private var selected: Bool = false
    private let imageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellPressed(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.all()
    }
    
}

// MARK: - Extensions

extension CardInfoEditCell {
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    func setSelected(selected: Bool) {
        self.selected = selected
        if selected {
            imageView.layer.borderColor = UIColor.wineRed.cgColor
        }
        else {
            imageView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        }
    }
}

// MARK: Private Extensions

private extension CardInfoEditCell {
    @objc func cellPressed(_ sender: UITapGestureRecognizer) {
        if let idx = sender.view?.tag {
            delegate?.cellPressed(idx: idx)
        }
    }
}
