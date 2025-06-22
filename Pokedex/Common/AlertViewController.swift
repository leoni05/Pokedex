//
//  AlertViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/19/25.
//

import Foundation
import UIKit
import PinLayout

protocol AlertViewControllerDelegate: AnyObject {
    func buttonPressed(buttonType: AlertButtonType)
}

class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var alertType: AlertType = .alert
    weak var delegate: AlertViewControllerDelegate? = nil
    
    var titleText = "Title"
    var contentText = "Content"
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let cancelButton = UIButton()
    private let okButton = UIButton()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        self.view.addSubview(backgroundView)
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 4.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.wineRed.cgColor
        self.view.addSubview(containerView)
        
        titleLabel.text = titleText
        titleLabel.font = UIFont(name: "Galmuri11-Bold", size: 16)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .wineRed
        containerView.addSubview(titleLabel)
        
        let attrString = NSMutableAttributedString(string: contentText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        paragraphStyle.lineBreakMode = .byWordWrapping
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
        contentLabel.font = UIFont(name: "Galmuri11-Regular", size: 14)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .wineRed
        containerView.addSubview(contentLabel)
        
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.wineRed.cgColor
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.wineRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 16)
        if alertType == .alert {
            cancelButton.isHidden = true
        }
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(cancelButton)
        
        okButton.layer.cornerRadius = 4.0
        okButton.layer.borderWidth = 1.0
        okButton.layer.borderColor = UIColor.wineRed.cgColor
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .wineRed
        okButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 16)
        okButton.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(okButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.pin.all()
        
        containerView.pin.width(300)
        titleLabel.pin.top(24).horizontally(24).sizeToFit()
        contentLabel.pin.below(of: titleLabel).horizontally(24).marginTop(8).sizeToFit(.width)
        
        let buttonWidth: CGFloat = 122
        cancelButton.pin.below(of: contentLabel).left(24).width((alertType == .confirm) ? buttonWidth : 0.0)
            .height(40).marginTop(32)
        okButton.pin.after(of: cancelButton, aligned: .top).right(24).height(40)
            .marginLeft((alertType == .confirm) ? 8.0 : 0.0)
        containerView.pin.center().width(300).height(okButton.frame.maxY + 24.0)
    }
    
}

// MARK: - Private Extensions

private extension AlertViewController {
    @objc func okButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(buttonType: .ok)
        self.dismiss(animated: false)
    }
    
    @objc func cancelButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(buttonType: .cancel)
        self.dismiss(animated: false)
    }
}
