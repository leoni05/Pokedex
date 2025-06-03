//
//  SettingViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout

class SettingViewController: UIViewController {
    
    // MARK: - Properties

    private let label = UILabel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        label.text = "SettingViewController"
        label.textColor = .wineRed
        label.font = UIFont(name: "Galmuri11-Bold", size: 14)
        self.view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.pin.center().sizeToFit()
    }
    
}
