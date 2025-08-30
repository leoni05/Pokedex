//
//  SamuelOakViewController.swift
//  Pokedex
//
//  Created by jyj on 8/30/25.
//

import Foundation
import UIKit
import PinLayout

class SamuelOakViewController: UIViewController {
    
    // MARK: - Properties
    
    private let samuelOakWrapperView = UIView()
    private let samuelOakImageView = UIImageView()
    private let speechBubbleView = SpeechBubbleView()
    private let arrowLabelWrapper = UIView()
    private let arrowLabel = UILabel()
    private var timerForBlink: Timer? = nil
    private let speechLabel = UILabel()
    private let confirmBubbleView = SpeechBubbleView()
    private let okButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(samuelOakWrapperView)
        
        samuelOakImageView.image = UIImage(named: "SamuelOak")
        samuelOakImageView.contentMode = .scaleAspectFit
        samuelOakWrapperView.addSubview(samuelOakImageView)
        
        self.view.addSubview(speechBubbleView)
        
        speechLabel.text = "포켓몬스터의 세계에 잘 왔단다!"
        speechLabel.textColor = .wineRed
        speechLabel.numberOfLines = 3
        speechLabel.font = UIFont(name: "Galmuri11-Regular", size: 16)
        speechBubbleView.addSubview(speechLabel)
        
        arrowLabelWrapper.isHidden = true
        arrowLabelWrapper.backgroundColor = .white
        self.view.addSubview(arrowLabelWrapper)
        
        arrowLabel.text = "▼"
        arrowLabel.textColor = .wineRed
        arrowLabel.textAlignment = .center
        arrowLabel.font = UIFont(name: "Galmuri11-Bold", size: 13)
        arrowLabelWrapper.addSubview(arrowLabel)
        
        confirmBubbleView.isHidden = true
        self.view.addSubview(confirmBubbleView)
        
        okButton.setTitle("예", for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Galmuri11-Regular", size: 16)
        okButton.setTitleColor(.wineRed, for: .normal)
        confirmBubbleView.addSubview(okButton)
        
        cancelButton.setTitle("아니오", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Galmuri11-Regular", size: 16)
        cancelButton.setTitleColor(.wineRed, for: .normal)
        confirmBubbleView.addSubview(cancelButton)
        
        setArrowLabel(hidden: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenPressed(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        speechBubbleView.pin.bottom(self.view.pin.safeArea+4).horizontally(self.view.pin.safeArea+4)
            .height(100)
        speechLabel.pin.top(14).horizontally(16).sizeToFit(.width)
        arrowLabelWrapper.pin.vCenter(to: speechBubbleView.edge.bottom).right(to: speechBubbleView.edge.right)
            .size(18).marginRight(12).marginTop(-2)
        arrowLabel.pin.center().sizeToFit()
        
        okButton.pin.left().top().height(50).width(80)
        cancelButton.pin.below(of: okButton, aligned: .left).height(50).width(80).marginBottom(4)
        confirmBubbleView.pin.above(of: speechBubbleView, aligned: .right).wrapContent(padding: 4).marginBottom(8)
        
        samuelOakWrapperView.pin.above(of: speechBubbleView)
            .top(self.view.pin.safeArea).horizontally(self.view.pin.safeArea)
        samuelOakImageView.pin.center().size(220)
    }
    
}

private extension SamuelOakViewController {
    func setArrowLabel(hidden: Bool) {
        if hidden {
            arrowLabelWrapper.isHidden = true
            timerForBlink?.invalidate()
            timerForBlink = nil
        }
        else {
            arrowLabelWrapper.isHidden = false
            timerForBlink = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                self.arrowLabelWrapper.isHidden = !self.arrowLabelWrapper.isHidden
            }
        }
    }
    
    @objc func screenPressed(_ sender: UITapGestureRecognizer) {
        if timerForBlink == nil {
            return
        }
        self.setArrowLabel(hidden: true)
        speechLabel.text = "포켓몬스터 데이터를 다운로드 받을 준비는 되었는가?\n(Wi-Fi 환경 이용을 절대 권장합니다)"
        speechLabel.pin.top(14).horizontally(16).sizeToFit(.width)
        
        confirmBubbleView.isHidden = false
    }
}
