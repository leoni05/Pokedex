//
//  ViewController.swift
//  Pokedex
//
//  Created by leoni05 on 5/3/25.
//

import UIKit
import PinLayout

class MainViewController: UIViewController {
    
    // MARK: - Properties

    private let mainUpperView = MainUpperView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(mainUpperView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainUpperView.pin.top(self.view.pin.safeArea).horizontally(self.view.pin.safeArea)
            .height(72)
    }

}

