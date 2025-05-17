//
//  MainUpperView.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import UIKit

class MainUpperView: UIView {
    
    // MARK: - Properties
    
    private let leftSegXDiff: CGFloat = 190.0
    private let diagonalXDiff: CGFloat = 30.0
    
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
        self.isOpaque = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    override func draw(_ rect: CGRect) {
        let p1 = CGPoint(x: 0, y: rect.height-1.0)
        let p2 = CGPoint(x: leftSegXDiff-7.0, y: rect.height-1.0)
        let cp2 = CGPoint(x: leftSegXDiff, y: rect.height-1.0)
        let p3 = CGPoint(x: leftSegXDiff+(7.0/1.414), y: rect.height-1.0-(7.0/1.414))
        let p4 = CGPoint(x: leftSegXDiff+diagonalXDiff-(7.0/1.414), y: rect.height-1.0-diagonalXDiff+(7.0/1.414))
        let cp4 = CGPoint(x: leftSegXDiff+diagonalXDiff, y: rect.height-1.0-diagonalXDiff)
        let p5 = CGPoint(x: leftSegXDiff+diagonalXDiff+(7.0/1.414), y: rect.height-1.0-diagonalXDiff)
        let p6 = CGPoint(x: rect.width, y: rect.height-1.0-diagonalXDiff)
        
        let path1 = UIBezierPath()
        path1.move(to: .zero)
        path1.addLine(to: p1)
        path1.addLine(to: p2)
        path1.addQuadCurve(to: p3, controlPoint: cp2)
        path1.addLine(to: p4)
        path1.addQuadCurve(to: p5, controlPoint: cp4)
        path1.addLine(to: p6)
        path1.addLine(to: CGPoint(x: rect.width, y: 0.0))
        path1.addLine(to: .zero)
        path1.close()
        UIColor.white.set()
        path1.fill()
        
        let path2 = UIBezierPath()
        path2.lineWidth = 2
        path2.lineJoinStyle = .round
        path2.move(to: p1)
        path2.addLine(to: p2)
        path2.addQuadCurve(to: p3, controlPoint: cp2)
        path2.addLine(to: p4)
        path2.addQuadCurve(to: p5, controlPoint: cp4)
        path2.addLine(to: p6)
        UIColor.wineRed.set()
        path2.stroke()
    }
    
}
