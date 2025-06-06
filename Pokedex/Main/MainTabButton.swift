//
//  MainTabButton.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import UIKit
import PinLayout

class MainTabButton: UIButton {
    
    // MARK: - Properties
    
    var tabType: TabType? = nil
    private let containerView = UIView()
    private let btnImageView = UIImageView()
    private let btnLabel = UILabel()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(tabType: TabType, labelString: String) {
        super.init(frame: .zero)
        
        btnLabel.text = labelString
        btnLabel.textColor = .wineRed
        btnLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        
        self.tabType = tabType
        btnImageView.image = UIImage(named: tabType.rawValue)
        btnImageView.contentMode = .scaleAspectFit
        
        commonInit()
    }
    
    private func commonInit() {
        containerView.isUserInteractionEnabled = false
        addSubview(containerView)
        containerView.addSubview(btnImageView)
        containerView.addSubview(btnLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btnImageView.pin.top().left().size(24)
        btnLabel.pin.below(of: btnImageView, aligned: .center).marginTop(4).sizeToFit()
        containerView.pin.center().wrapContent()
    }
    
}

// MARK: - Extensions

extension MainTabButton {
    func setStatus(activated: Bool) {
        if let tabType = tabType {
            let imageName = tabType.rawValue + (activated ? ".fill" : "")
            btnImageView.image = UIImage(named: imageName)
        }
    }
}
