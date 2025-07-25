//
//  CardInfoEditViewController.swift
//  Pokedex
//
//  Created by jyj on 7/24/25.
//

import Foundation
import UIKit
import PinLayout

class CardInfoEditViewController: UIViewController {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let cardInfoLabel = UILabel()
    private let nameTextField = UITextField()
    private let imageLabel = UILabel()
    private let imageViewsContainer = UIView()
    private var trainerImageViews: Array<UIImageView> = []
    private let trainerImageCount = 24
    
    private let okButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        cardInfoLabel.text = "트레이너 정보 입력"
        cardInfoLabel.textColor = .wineRed
        cardInfoLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        scrollView.addSubview(cardInfoLabel)
        
        scrollView.addSubview(nameTextField)
        
        imageLabel.text = "대표 이미지 설정"
        imageLabel.textColor = .wineRed
        imageLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        scrollView.addSubview(imageLabel)
        
        scrollView.addSubview(imageViewsContainer)
        
        for idx in 0..<trainerImageCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "TrainerImage" + String(format: "%02d", idx))
            imageView.layer.cornerRadius = 4.0
            imageView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            imageView.layer.borderWidth = 1.0
            imageView.layer.masksToBounds = true
            trainerImageViews.append(imageView)
            imageViewsContainer.addSubview(imageView)
        }
        
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = UIColor.wineRed.cgColor
        okButton.backgroundColor = .white
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.wineRed, for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        okButton.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(okButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        cardInfoLabel.pin.top(MainUpperView.topInset + 16).horizontally(16).sizeToFit(.width)
        nameTextField.pin.below(of: cardInfoLabel).horizontally(16).height(40).marginTop(12)
        imageLabel.pin.below(of: nameTextField).horizontally(16).marginTop(24).sizeToFit(.width)
        imageViewsContainer.pin.below(of: imageLabel).horizontally(16).marginTop(12)
        for idx in 0..<trainerImageViews.count {
            let imageView = trainerImageViews[idx]
            let gap: CGFloat = 12
            let imageWidth: CGFloat = (imageViewsContainer.frame.width - gap)/2
            let imageHeight: CGFloat = (imageWidth * 80) / 158
            let x: CGFloat = ((idx%2==0) ? 0.0 : imageWidth+gap)
            let y: CGFloat = CGFloat(Int(idx/2)) * (imageHeight + gap)
            imageView.pin.left(x).top(y).width(imageWidth).height(imageHeight)
        }
        imageViewsContainer.pin.below(of: imageLabel).left(16).wrapContent().marginTop(12)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: imageViewsContainer.frame.maxY + 84)
        
        okButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
}

// MARK: - Private Extensions

private extension CardInfoEditViewController {
    @objc func okButtonPressed(_ sender: UIButton) {
        
    }
}
