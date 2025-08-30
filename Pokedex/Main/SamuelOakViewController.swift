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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        samuelOakImageView.image = UIImage(named: "SamuelOak")
        samuelOakImageView.contentMode = .scaleAspectFit
        self.view.addSubview(samuelOakImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        samuelOakImageView.pin.center().size(220)
    }
    
}
