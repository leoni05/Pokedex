//
//  MainTabBarView.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import PinLayout
import UIKit

protocol MainTabBarViewDelegate: AnyObject {
    func touchUpInsideButton(type: TabType?)
}

class MainTabBarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MainTabBarViewDelegate?
    private let btnWidth: CGFloat = 60.0
    private let containerView = UIView()
    private let pokedexTabButton = MainTabButton(tabType: .pokedex, labelString: "도감")
    private let galleryTabButton = MainTabButton(tabType: .gallery, labelString: "갤러리")
    private let cardTabButton = MainTabButton(tabType: .card, labelString: "트레이너")
    private let settingTabButton = MainTabButton(tabType: .setting, labelString: "설정")
    private let pokeBallTabButton = PokeballButton()
    private var tabButtonDict: [TabType? : MainTabButton] = [:]
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        
        addSubview(containerView)
        tabButtonDict = [
            TabType.pokedex : pokedexTabButton,
            TabType.gallery : galleryTabButton,
            TabType.card : cardTabButton,
            TabType.setting : settingTabButton
        ]
        for (_, button) in tabButtonDict {
            button.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
            containerView.addSubview(button)
        }
        pokeBallTabButton.addTarget(self, action: #selector(touchUpInsidePokeball(_:)), for: .touchUpInside)
        containerView.addSubview(pokeBallTabButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spacing = (frame.width-(btnWidth*5)) / 10.0
    
        containerView.pin.top(2).horizontally().bottom()
        pokeBallTabButton.pin.center().size(btnWidth)
        
        galleryTabButton.pin.before(of: pokeBallTabButton).vertically().width(btnWidth).marginRight(2 * spacing)
        pokedexTabButton.pin.before(of: galleryTabButton).vertically().width(btnWidth).marginRight(2 * spacing)
        cardTabButton.pin.after(of: pokeBallTabButton).vertically().width(btnWidth).marginLeft(2 * spacing)
        settingTabButton.pin.after(of: cardTabButton).vertically().width(btnWidth).marginLeft(2 * spacing)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.move(to: CGPoint(x: 0.0, y: 1.0))
        path.addLine(to: CGPoint(x: rect.width, y: 1.0))
        UIColor.wineRed.set()
        path.stroke()
    }
    
}

// MARK: - Private Extensions

private extension MainTabBarView {
    @objc func touchUpInsideButton(_ sender: MainTabButton) {
        delegate?.touchUpInsideButton(type: sender.tabType)
    }
    
    @objc func touchUpInsidePokeball(_ sender: PokeballButton) {
        delegate?.touchUpInsideButton(type: sender.tabType)
    }
}

// MARK: - Extensions

extension MainTabBarView {
    func setButtonStatus(tabType: TabType?, activated: Bool) {
        if tabType == .camera {
            pokeBallTabButton.setStatus(activated: activated)
        }
        else {
            tabButtonDict[tabType]?.setStatus(activated: activated)
        }
    }
}
