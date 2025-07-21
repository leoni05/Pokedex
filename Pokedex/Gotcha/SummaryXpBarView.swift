//
//  SummaryXpBarView.swift
//  Pokedex
//
//  Created by jyj on 7/22/25.
//

import Foundation
import UIKit
import PinLayout

class SummaryXpBarView: UIView {
    var percentVal: CGFloat = 25.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setFillColor(red: 80.0/255.0, green: 104.0/255.0, blue: 88/255.0, alpha: 1.0)
        ctx.fill(CGRect(x: 8, y: 0, width: rect.width-16, height: 3))
        ctx.fill(CGRect(x: 4, y: 3, width: 4, height: 3))
        ctx.fill(CGRect(x: rect.width-8, y: 3, width: 4, height: 3))
        ctx.fill(CGRect(x: 0, y: 6, width: 4, height: rect.height-12))
        ctx.fill(CGRect(x: rect.width-4, y: 6, width: 4, height: rect.height-12))
        ctx.fill(CGRect(x: 4, y: rect.height-6, width: 4, height: 3))
        ctx.fill(CGRect(x: rect.width-8, y: rect.height-6, width: 4, height: 3))
        ctx.fill(CGRect(x: 8, y: rect.height-3, width: rect.width-16, height: 3))
        
        let innerWidth = max(0, frame.width-16)
        let innerHeight = max(0, frame.height-12)
        let filledWidth = innerWidth * (percentVal/100.0)
        let unfilledWidth = max(0, innerWidth-filledWidth)
        
        ctx.setFillColor(red: 88.0/255.0, green: 208.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        ctx.fill(CGRect(x: 8, y: 6, width: filledWidth, height: 3))
        ctx.setFillColor(red: 72.0/255.0, green: 64.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        ctx.fill(CGRect(x: 8+filledWidth, y: 6, width: unfilledWidth, height: 3))
        ctx.setFillColor(red: 112.0/255.0, green: 248.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        ctx.fill(CGRect(x: 8, y: 9, width: filledWidth, height: innerHeight-3))
        ctx.setFillColor(red: 80.0/255.0, green: 104.0/255.0, blue: 88/255.0, alpha: 1.0)
        ctx.fill(CGRect(x: 8+filledWidth, y: 9, width: unfilledWidth, height: innerHeight-3))
    }
}
