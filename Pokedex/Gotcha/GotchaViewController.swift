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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentingVC == nil {
            addCameraVC()
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
            removeCameraVC()
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

// MARK: - Private Extensions

private extension GotchaViewController {
    @objc func didReceiveNotification(_ notification: Notification) {
        if notification.name == UIApplication.willEnterForegroundNotification {
            if presentingVC == nil {
                addCameraVC()
            }
        }
        if notification.name == UIApplication.didEnterBackgroundNotification {
            if presentingVC is CameraViewController {
                removeCameraVC()
            }
        }
    }
    
    func addCameraVC() {
        presentingVC = CameraViewController()
        if let vc = presentingVC {
            self.addChild(vc)
            vc.view.frame = .zero
            self.view.insertSubview(vc.view, at: 0)
            vc.view.didMoveToSuperview()
        }
    }
    
    func removeCameraVC() {
        if let vc = presentingVC {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        presentingVC = nil
    }
}
