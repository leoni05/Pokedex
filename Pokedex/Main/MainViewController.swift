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
    private let mainTabBarView = MainTabBarView()
    
    private var canChangeTab: Bool = true
    private var presentingTab: TabType? = nil
    private let tabVCDict: [TabType? : UIViewController] = [
        TabType.pokedex : PokedexViewController(),
        TabType.gallery : GalleryViewController(),
        TabType.camera : CameraViewController(),
        TabType.card : CardViewController(),
        TabType.setting : SettingViewController()
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(mainUpperView)
        
        mainTabBarView.delegate = self
        self.view.addSubview(mainTabBarView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainUpperView.pin.top(self.view.pin.safeArea).horizontally(self.view.pin.safeArea)
            .height(72)
        mainTabBarView.pin.bottom(self.view.pin.safeArea).horizontally(self.view.pin.safeArea)
            .height(72)
    }

}

// MARK: - Private Extensions

private extension MainViewController {
    func changeTab(type: TabType?) {
        if canChangeTab == false {
            return
        }
        if let vc = tabVCDict[presentingTab] {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            presentingTab = nil
        }
        if let vc = tabVCDict[type] {
            self.addChild(vc)
            vc.view.frame = .zero
            self.view.insertSubview(vc.view, at: 0)
            vc.view.didMoveToSuperview()
            presentingTab = type
            vc.view.pin.below(of: mainUpperView).above(of: mainTabBarView)
                .horizontally(self.view.pin.safeArea).marginTop(-MainUpperView.topInset)
        }
    }
}

// MARK: - MainTabBarViewDelegate

extension MainViewController: MainTabBarViewDelegate {
    func touchUpInsideButton(type: TabType?) {
        changeTab(type: type)
    }
}
