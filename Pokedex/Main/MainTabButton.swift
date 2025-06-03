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
    
    var tabButtonType: TabButtonType? = nil
    private let containerView = UIView()
    private let btnImageView = UIImageView()
    private let btnLabel = UILabel()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(tabButtonType: TabButtonType, labelString: String) {
        super.init(frame: .zero)
        
        btnLabel.text = labelString
        btnLabel.textColor = .wineRed
        btnLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        
        self.tabButtonType = tabButtonType
        btnImageView.image = UIImage(named: tabButtonType.rawValue)
        btnImageView.contentMode = .scaleAspectFit
        
        commonInit()
    }
    
    private func commonInit() {
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
