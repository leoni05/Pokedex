//
//  GotchaViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/17/25.
//

import Foundation
import UIKit
import PinLayout
import AVFoundation

class GotchaViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presentingVC: UIViewController? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentingVC == nil {
            presentingVC = CameraViewController()
            if let vc = presentingVC {
                self.addChild(vc)
                vc.view.frame = .zero
                self.view.insertSubview(vc.view, at: 0)
                vc.view.didMoveToSuperview()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let vc = presentingVC {
            vc.view.pin.all()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if presentingVC is CameraViewController {
            if let vc = presentingVC {
                vc.willMove(toParent: nil)
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
            presentingVC = nil
        }
    }
    
}

// MARK: - Extensions

extension GotchaViewController {
    func takePicture() {
        if let cameraVC = presentingVC as? CameraViewController {
            cameraVC.takePicture()
        }
    }
}
