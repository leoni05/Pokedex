//
//  MainTabBarView.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import UIKit

class MainTabBarView: UIView {
    
    // MARK: - Properties
    
    
    
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
