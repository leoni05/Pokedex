//
//  PokedexDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 7/27/25.
//

import Foundation
import UIKit
import PinLayout

protocol PokedexDetailViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class PokedexDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: PokedexDetailViewControllerDelegate? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.setBackButton(hidden: true)
    }

}
