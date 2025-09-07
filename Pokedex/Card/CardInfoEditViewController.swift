//
//  CardInfoEditViewController.swift
//  Pokedex
//
//  Created by jyj on 7/24/25.
//

import Foundation
import UIKit
import PinLayout

protocol CardInfoEditViewControllerDelegate: AnyObject {
    func cardEditOkButtonPressed()
}

class CardInfoEditViewController: UIViewController {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let cardInfoLabel = UILabel()
    private let nameTextField = UITextField()
    private let imageLabel = UILabel()
    private let imageCellsContainer = UIView()
    private var trainerImageCells: Array<CardInfoEditCell> = []
    private let trainerImageCount = 24
    private var selectedImageIdx: Int? = nil
    private let okButton = UIButton()
    
    private var initUserName: String? = nil
    private var initTrainerImageIdx: Int? = nil
    
    weak var delegate: CardInfoEditViewControllerDelegate? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        cardInfoLabel.text = "트레이너 정보 입력"
        cardInfoLabel.textColor = .wineRed
        cardInfoLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        scrollView.addSubview(cardInfoLabel)
        
        nameTextField.placeholder = "이름 입력"
        nameTextField.textColor = .wineRed
        nameTextField.font = UIFont(name: "Galmuri11-Regular", size: 14)
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.cornerRadius = 4.0
        nameTextField.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.masksToBounds = true
        nameTextField.clearButtonMode = .always
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        scrollView.addSubview(nameTextField)
        
        imageLabel.text = "대표 이미지 설정"
        imageLabel.textColor = .wineRed
        imageLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        scrollView.addSubview(imageLabel)
        
        scrollView.addSubview(imageCellsContainer)
        
        for idx in 0..<trainerImageCount {
            let cell = CardInfoEditCell()
            cell.setImage(image: UIImage(named: "TrainerImage" + String(format: "%02d", idx)))
            cell.tag = idx
            cell.delegate = self
            
            trainerImageCells.append(cell)
            imageCellsContainer.addSubview(cell)
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
        imageCellsContainer.pin.below(of: imageLabel).horizontally(16).marginTop(12)
        for idx in 0..<trainerImageCells.count {
            let imageCell = trainerImageCells[idx]
            let gap: CGFloat = 12
            let imageWidth: CGFloat = (imageCellsContainer.frame.width - gap)/2
            let imageHeight: CGFloat = (imageWidth * 80) / 158
            let x: CGFloat = ((idx%2==0) ? 0.0 : imageWidth+gap)
            let y: CGFloat = CGFloat(Int(idx/2)) * (imageHeight + gap)
            imageCell.pin.left(x).top(y).width(imageWidth).height(imageHeight)
        }
        imageCellsContainer.pin.below(of: imageLabel).left(16).wrapContent().marginTop(12)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: imageCellsContainer.frame.maxY + 84)
        
        okButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nameString = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) {
            initUserName = nameString
            nameTextField.text = nameString
        }
        if UserDefaults.standard.object(forKey: UserDefaultsKeys.trainerImageIdx) != nil {
            let trainerImageIdx = UserDefaults.standard.integer(forKey: UserDefaultsKeys.trainerImageIdx)
            initTrainerImageIdx = trainerImageIdx
            changeImageSelection(idx: trainerImageIdx)
        }
    }
    
}

// MARK: - Private Extensions

private extension CardInfoEditViewController {
    @objc func okButtonPressed(_ sender: UIButton) {
        let alertVC = AlertViewController()
        alertVC.alertType = .alert
        
        if (nameTextField.text?.count ?? 0) == 0 {
            alertVC.titleText = "트레이너 정보 입력"
            alertVC.contentText = "트레이너 이름을 입력해 주세요."
            self.present(alertVC, animated: true)
            return
        }
        if selectedImageIdx == nil {
            alertVC.titleText = "대표 이미지 설정"
            alertVC.contentText = "트레이너 대표 이미지를 설정해 주세요."
            self.present(alertVC, animated: true)
            return
        }
        if initUserName != nil && initTrainerImageIdx != nil &&
            (initUserName != nameTextField.text || initTrainerImageIdx != selectedImageIdx) {
            alertVC.titleText = "트레이너 정보 변경"
            alertVC.contentText = "변경되었습니다."
            alertVC.delegate = self
            self.present(alertVC, animated: true)
            return
        }
        UserDefaults.standard.set(nameTextField.text, forKey: UserDefaultsKeys.userName)
        UserDefaults.standard.set(selectedImageIdx, forKey: UserDefaultsKeys.trainerImageIdx)
        delegate?.cardEditOkButtonPressed()
    }
    
    func changeImageSelection(idx: Int) {
        if idx == selectedImageIdx { return }
        
        if let selectedImageIdx = selectedImageIdx {
            trainerImageCells[selectedImageIdx].setSelected(selected: false)
        }
        trainerImageCells[idx].setSelected(selected: true)
        selectedImageIdx = idx
    }
    
}

// MARK: - Extensions

extension CardInfoEditViewController {
    func scrollViewScrollToTop() {
        scrollView.setContentOffset(.zero, animated: false)
    }
}

// MARK: - UITextFieldDelegate

extension CardInfoEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - AlertViewControllerDelegate

extension CardInfoEditViewController: AlertViewControllerDelegate {
    func buttonPressed(buttonType: AlertButtonType, tag: Int?) {
        if buttonType == .ok {
            UserDefaults.standard.set(nameTextField.text, forKey: UserDefaultsKeys.userName)
            UserDefaults.standard.set(selectedImageIdx, forKey: UserDefaultsKeys.trainerImageIdx)
            delegate?.cardEditOkButtonPressed()
        }
    }
}

// MARK: - CardInfoEditCellDelegate

extension CardInfoEditViewController: CardInfoEditCellDelegate {
    func cellPressed(idx: Int) {
        changeImageSelection(idx: idx)
    }
}
