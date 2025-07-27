//
//  MainUpperView.swift
//  Pokedex
//
//  Created by leoni05 on 5/17/25.
//

import Foundation
import UIKit
import PinLayout

class LenseView: UIView {
    
    // MARK: - Properties
    
    private let outerCircleRadius: CGFloat = 23.0
    private let innerCircleRadius: CGFloat = 19.0
    private let shadowCircleRadius: CGFloat = 16.0
    private let eraseShadowCircleRadius: CGFloat = 9.5
    private let highlightCircleRadius: CGFloat = 4.0
    
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
    
    override func draw(_ rect: CGRect) {
        let outerCircle = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: outerCircleRadius,
                                       startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        UIColor.init(red: 0.867, green: 0.898, blue: 0.871, alpha: 1.0).setFill()
        outerCircle.fill()
        UIColor.wineRed.setStroke()
        outerCircle.stroke()
        
        let innerCircle = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: innerCircleRadius,
                                       startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        UIColor.init(red: 0.160, green: 0.655, blue: 0.980, alpha: 1.0).setFill()
        innerCircle.fill()
        UIColor.wineRed.setStroke()
        innerCircle.stroke()
        
        let shadowCircle = UIBezierPath(arcCenter: CGPoint(x: rect.midX+1.6, y: rect.midY+1.6), radius: shadowCircleRadius,
                                       startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        UIColor.init(red: 0.106, green: 0.408, blue: 0.631, alpha: 1.0).setFill()
        shadowCircle.fill()
        
        let eraseShadowCircle = UIBezierPath(arcCenter: CGPoint(x: rect.midX-3.5, y:rect.midY-3.5), radius: eraseShadowCircleRadius,
                                             startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        UIColor.init(red: 0.160, green: 0.655, blue: 0.980, alpha: 1.0).setFill()
        eraseShadowCircle.fill()
        
        let highlightCircle = UIBezierPath(arcCenter: CGPoint(x: rect.midX-7.0, y: rect.midY-7.0), radius: highlightCircleRadius,
                                       startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        UIColor.init(red: 0.639, green: 0.847, blue: 0.980, alpha: 1.0).setFill()
        highlightCircle.fill()
    }
}

protocol MainUpperViewDelegate: AnyObject {
    func backButtonPressed()
}

class MainUpperView: UIView {
    
    // MARK: - Properties
    
    static let topInset: CGFloat = 23.0
    private let leftSegXDiff: CGFloat = 160.0
    private let diagonalXDiff: CGFloat = MainUpperView.topInset
    
    private let lenseView = LenseView()
    
    private let dotViewSize: CGFloat = 12.0
    private let redDotView = UIView()
    private let yellowDotView = UIView()
    private let greenDotView = UIView()
    private var viewPath = UIBezierPath()
    
    private let backButton = UIButton()
    weak var delegate: MainUpperViewDelegate? = nil
    
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
        addSubview(lenseView)
        
        redDotView.layer.cornerRadius = dotViewSize/2.0
        redDotView.backgroundColor = UIColor.init(red: 0.863, green: 0.039, blue: 0.176, alpha: 1.0)
        redDotView.layer.borderColor = UIColor.wineRed.cgColor
        redDotView.layer.borderWidth = 1.0
        addSubview(redDotView)
        
        yellowDotView.layer.cornerRadius = dotViewSize/2.0
        yellowDotView.backgroundColor = UIColor.init(red: 0.984, green: 0.902, blue: 0.247, alpha: 1.0)
        yellowDotView.layer.borderColor = UIColor.wineRed.cgColor
        yellowDotView.layer.borderWidth = 1.0
        addSubview(yellowDotView)
        
        greenDotView.layer.cornerRadius = dotViewSize/2.0
        greenDotView.backgroundColor = UIColor.init(red: 0.576, green: 0.851, blue: 0.631, alpha: 1.0)
        greenDotView.layer.borderColor = UIColor.wineRed.cgColor
        greenDotView.layer.borderWidth = 1.0
        addSubview(greenDotView)
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        backButton.isHidden = true
        addSubview(backButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lenseView.pin.top(12).left(16).size(48)
        redDotView.pin.top(12).left(74).size(dotViewSize)
        yellowDotView.pin.top(12).left(94).size(dotViewSize)
        greenDotView.pin.top(12).left(114).size(dotViewSize)
        backButton.pin.top(15).left(16).size(40)
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
        viewPath = path1
        
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return viewPath.contains(point)
    }
    
}

// MARK: - Private Extensions

private extension MainUpperView {
    @objc func backButtonPressed(_ sender: UIButton) {
        delegate?.backButtonPressed()
    }
}

// MARK: - Extensions

extension MainUpperView {
    func setBackButton(hidden: Bool) {
        if backButton.isHidden == hidden { return }

        if hidden {
            backButton.isHidden = true
            for view in [lenseView, redDotView, yellowDotView, greenDotView] {
                view.alpha = 0.0
                view.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    view.alpha = 1.0
                }
            }
        }
        else {
            backButton.alpha = 0.0
            backButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.backButton.alpha = 1.0
            }
            for view in [lenseView, redDotView, yellowDotView, greenDotView] {
                view.isHidden = true
            }
        }
    }
}
