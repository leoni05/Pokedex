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
    
    private let samuelOakImageView = UIImageView()
    private let speechBubbleView = SpeechBubbleView()
    private let arrowLabelWrapper = UIView()
    private let arrowLabel = UILabel()
    private var timerForBlink: Timer? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        samuelOakImageView.image = UIImage(named: "SamuelOak")
        samuelOakImageView.contentMode = .scaleAspectFit
        self.view.addSubview(samuelOakImageView)
        
        self.view.addSubview(speechBubbleView)
        
        arrowLabelWrapper.isHidden = true
        arrowLabelWrapper.backgroundColor = .white
        self.view.addSubview(arrowLabelWrapper)
        
        arrowLabel.text = "▼"
        arrowLabel.textColor = .wineRed
        arrowLabel.textAlignment = .center
        arrowLabel.font = UIFont(name: "Galmuri11-Bold", size: 13)
        arrowLabelWrapper.addSubview(arrowLabel)
        
        setArrowLabel(hidden: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        samuelOakImageView.pin.center().size(220)
        speechBubbleView.pin.bottom(self.view.pin.safeArea+4).horizontally(self.view.pin.safeArea+4)
            .height(100)
        arrowLabelWrapper.pin.vCenter(to: speechBubbleView.edge.bottom).right(to: speechBubbleView.edge.right)
            .size(18).marginRight(12).marginTop(-2)
        arrowLabel.pin.center().sizeToFit()
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
}
