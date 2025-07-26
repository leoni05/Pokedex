//
//  SettingViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

protocol SettingViewControllerDelegate: AnyObject {
    func cardInfoEditButtonPressed()
}

class SettingViewController: UIViewController {
    
    // MARK: - Properties

    private let titleLabel = UILabel()
    private let cardInfoEditButton = SettingItemButton()
    
    weak var delegate: SettingViewControllerDelegate? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "설정"
        titleLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        titleLabel.textColor = .wineRed
        self.view.addSubview(titleLabel)
        
        cardInfoEditButton.setText(text: "트레이너 이름 & 이미지 변경")
        cardInfoEditButton.addTarget(self, action: #selector(cardInfoEditButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(cardInfoEditButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.pin.top(MainUpperView.topInset + 16).horizontally(16).sizeToFit(.width)
        cardInfoEditButton.pin.below(of: titleLabel).horizontally(16).height(40).marginTop(16)
    }
    
}

// MARK: - Private Extension

private extension SettingViewController {
    @objc func cardInfoEditButtonPressed(_ sender: UIButton) {
        delegate?.cardInfoEditButtonPressed()
    }
}
