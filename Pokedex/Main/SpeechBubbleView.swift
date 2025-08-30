//
//  SpeechBubbleView.swift
//  Pokedex
//
//  Created by jyj on 8/30/25.
//

import Foundation
import UIKit
import PinLayout

class SpeechBubbleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        if rect.height < 18 || rect.width < 24 { return }
        
        ctx.setFillColor(UIColor.wineRed.cgColor)
        ctx.fill(CGRect(x: 8, y: 0, width: rect.width-16, height: 3))
        ctx.fill(CGRect(x: 4, y: 3, width: 4, height: 3))
        ctx.fill(CGRect(x: rect.width-8, y: 3, width: 4, height: 3))
        ctx.fill(CGRect(x: 0, y: 6, width: 4, height: rect.height-12))
        ctx.fill(CGRect(x: rect.width-4, y: 6, width: 4, height: rect.height-12))
        ctx.fill(CGRect(x: 4, y: rect.height-6, width: 4, height: 3))
        ctx.fill(CGRect(x: rect.width-8, y: rect.height-6, width: 4, height: 3))
        ctx.fill(CGRect(x: 8, y: rect.height-3, width: rect.width-16, height: 3))
    }
}
