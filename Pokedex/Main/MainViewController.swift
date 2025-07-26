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
        TabType.gotcha : GotchaViewController(),
        TabType.card : CardViewController(),
        TabType.cardInfoEdit : CardInfoEditViewController(),
        TabType.setting : SettingViewController()
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        (tabVCDict[.cardInfoEdit] as? CardInfoEditViewController)?.delegate = self
        
        if UserDefaults.standard.string(forKey: "userName") == nil {
            presentingTab = .cardInfoEdit
        }
        else {
            presentingTab = .pokedex
        }
        if let vc = tabVCDict[presentingTab] {
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.view.didMoveToSuperview()
        }
        mainTabBarView.setButtonStatus(tabType: presentingTab, activated: true)
        
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
        if let vc = tabVCDict[presentingTab] {
            vc.view.pin.below(of: mainUpperView).above(of: mainTabBarView)
                .horizontally(self.view.pin.safeArea).marginTop(-MainUpperView.topInset)
        }
    }

}

// MARK: - Private Extensions

private extension MainViewController {
    func changeTab(type: TabType?) {
        if let vc = tabVCDict[presentingTab] {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        mainTabBarView.setButtonStatus(tabType: presentingTab, activated: false)
        presentingTab = type
        if let vc = tabVCDict[presentingTab] {
            self.addChild(vc)
            vc.view.frame = .zero
            self.view.insertSubview(vc.view, at: 0)
            vc.view.didMoveToSuperview()
        }
        mainTabBarView.setButtonStatus(tabType: presentingTab, activated: true)
    }
}

// MARK: - MainTabBarViewDelegate

extension MainViewController: MainTabBarViewDelegate {
    func touchUpInsideButton(type: TabType?) {
        if presentingTab == .cardInfoEdit { return }
        
        if type == .gotcha && presentingTab == .gotcha {
            if let vc = tabVCDict[TabType.gotcha] as? GotchaViewController {
                vc.takePicture()
            }
        }
        else if canChangeTab && type != presentingTab {
            changeTab(type: type)
        }
    }
}

// MARK: - CardInfoEditViewControllerDelegate

extension MainViewController: CardInfoEditViewControllerDelegate {
    func cardEditOkButtonPressed() {
        changeTab(type: .pokedex)
    }
}
