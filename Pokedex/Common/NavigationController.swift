//
//  NavigationController.swift
//  Pokedex
//
//  Created by jyj on 7/27/25.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    /// Custom back buttons disable the interactive pop animation
    /// To enable it back we set the recognizer to `self`
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
