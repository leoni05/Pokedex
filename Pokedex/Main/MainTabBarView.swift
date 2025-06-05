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
    private let cameraTabButton = MainTabButton(tabType: .camera, labelString: "추가")
    private let cardTabButton = MainTabButton(tabType: .card, labelString: "트레이너")
    private let settingTabButton = MainTabButton(tabType: .setting, labelString: "설정")
    private let pokeBallTabButton = UIButton()
    
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
        pokeBallTabButton.setImage(UIImage(named: "tab.pokeball"), for: .normal)
        
        addSubview(containerView)
        
        pokedexTabButton.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        containerView.addSubview(pokedexTabButton)
        
        galleryTabButton.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        containerView.addSubview(galleryTabButton)
        
        cameraTabButton.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        containerView.addSubview(cameraTabButton)
        
        cardTabButton.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        containerView.addSubview(cardTabButton)
        
        settingTabButton.addTarget(self, action: #selector(touchUpInsideButton(_:)), for: .touchUpInside)
        containerView.addSubview(settingTabButton)
        
        pokeBallTabButton.alpha = 0.0
        pokeBallTabButton.isHidden = true
        containerView.addSubview(pokeBallTabButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spacing = (frame.width-(btnWidth*5)) / 10.0
    
        containerView.pin.top(2).horizontally().bottom()
        cameraTabButton.pin.vertically().hCenter().width(btnWidth)
        pokeBallTabButton.pin.vertically().hCenter().width(btnWidth)
        
        galleryTabButton.pin.before(of: cameraTabButton).vertically().width(btnWidth).marginRight(2 * spacing)
        pokedexTabButton.pin.before(of: galleryTabButton).vertically().width(btnWidth).marginRight(2 * spacing)
        cardTabButton.pin.after(of: cameraTabButton).vertically().width(btnWidth).marginLeft(2 * spacing)
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
}
