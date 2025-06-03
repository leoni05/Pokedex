//
//  MainTabBarView.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import PinLayout
import UIKit

class MainTabBarView: UIView {
    
    // MARK: - Properties
    
    private let btnWidth: CGFloat = 60.0
    private let containerView = UIView()
    private let pokedexTabButton = MainTabButton(imageName: "TabPokedex", labelString: "도감")
    private let galleryTabButton = MainTabButton(imageName: "TabGallery", labelString: "갤러리")
    private let cameraTabButton = MainTabButton(imageName: "TabCamera", labelString: "추가")
    private let cardTabButton = MainTabButton(imageName: "TabCard", labelString: "트레이너")
    private let settingTabButton = MainTabButton(imageName: "TabSetting", labelString: "설정")
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
        pokeBallTabButton.setImage(UIImage(named: "TabPokeBall"), for: .normal)
        
        addSubview(containerView)
        
        containerView.addSubview(pokedexTabButton)
        containerView.addSubview(galleryTabButton)
        containerView.addSubview(cameraTabButton)
        containerView.addSubview(cardTabButton)
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
