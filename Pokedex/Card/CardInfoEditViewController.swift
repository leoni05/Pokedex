//
//  CardInfoEditViewController.swift
//  Pokedex
//
//  Created by jyj on 7/24/25.
//

import Foundation
import UIKit
import PinLayout

class CardInfoEditViewController: UIViewController {
    
    // MARK: - Properties

    private let okButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = UIColor.wineRed.cgColor
        okButton.backgroundColor = .white
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.wineRed, for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        okButton.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(okButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        okButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
}

// MARK: - Private Extensions

private extension CardInfoEditViewController {
    @objc func okButtonPressed(_ sender: UIButton) {
        
    }
}
