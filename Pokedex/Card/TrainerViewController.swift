//
//  TrainerViewController.swift
//  Pokedex
//
//  Created by jyj on 9/7/25.
//

import Foundation
import UIKit
import PinLayout

protocol TrainerViewControllerDelegate: AnyObject {
    func setBackButtonForTrainer(hidden: Bool)
}

class TrainerViewController: NavigationController {
    
    // MARK: - Properties

    weak var vcDelegate: TrainerViewControllerDelegate? = nil
    private var cardVC = CardViewController()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.isNavigationBarHidden = true
        self.pushViewController(cardVC, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.popToRootViewController(animated: false)
    }
    
}

// MARK: - SelectPokemonViewControllerDelegate

extension TrainerViewController: SelectPokemonViewControllerDelegate {
    func setBackButton(hidden: Bool) {
        vcDelegate?.setBackButtonForTrainer(hidden: hidden)
    }
}
