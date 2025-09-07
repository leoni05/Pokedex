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

    private var firstCardInfoSetting = false
    private let mainUpperView = MainUpperView()
    private let mainTabBarView = MainTabBarView()
    
    private var canChangeTab: Bool = true
    private var presentingTab: TabType? = nil
    private let tabVCDict: [TabType? : UIViewController] = [
        TabType.pokedex : PokedexViewController(),
        TabType.gallery : GalleryViewController(),
        TabType.gotcha : GotchaViewController(),
        TabType.card : TrainerViewController(),
        TabType.cardInfoEdit : CardInfoEditViewController(),
        TabType.setting : SettingViewController()
    ]
    private var samuelOakVC: SamuelOakViewController? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        (tabVCDict[TabType.pokedex] as? PokedexViewController)?.vcDelegate = self
        (tabVCDict[TabType.gallery] as? GalleryViewController)?.vcDelegate = self
        (tabVCDict[TabType.cardInfoEdit] as? CardInfoEditViewController)?.delegate = self
        (tabVCDict[TabType.setting] as? SettingViewController)?.delegate = self
        
        if UserDefaults.standard.string(forKey: "userName") == nil {
            firstCardInfoSetting = true
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
        
        mainUpperView.delegate = self
        self.view.addSubview(mainUpperView)
        
        mainTabBarView.delegate = self
        self.view.addSubview(mainTabBarView)
        
        if UserDefaults.standard.integer(forKey: "lastDownloadedPokemon") < Pokedex.totalNumber {
            samuelOakVC = SamuelOakViewController()
            if let samuelOakVC = samuelOakVC {
                samuelOakVC.delegate = self
                self.addChild(samuelOakVC)
                self.view.addSubview(samuelOakVC.view)
                samuelOakVC.view.didMoveToSuperview()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let sameulOakVC = samuelOakVC {
            sameulOakVC.view.pin.all()
        }
        
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
            
            if presentingTab == .cardInfoEdit {
                (vc as? CardInfoEditViewController)?.scrollViewScrollToTop()
            }
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
        if firstCardInfoSetting {
            firstCardInfoSetting = false
            changeTab(type: .pokedex)
        }
        else {
            changeTab(type: .setting)
        }
    }
}

// MARK: - SettingViewControllerDelegate

extension MainViewController: SettingViewControllerDelegate {
    func cardInfoEditButtonPressed() {
        changeTab(type: .cardInfoEdit)
    }
}

// MARK: - PokedexViewControllerDelegate

extension MainViewController: PokedexViewControllerDelegate {
    func setBackButtonForPokedex(hidden: Bool) {
        mainUpperView.setBackButton(hidden: hidden)
    }
}

// MARK: - GalleryViewControllerDelegate

extension MainViewController: GalleryViewControllerDelegate {
    func setBackButtonForGallery(hidden: Bool) {
        mainUpperView.setBackButton(hidden: hidden)
    }
}

// MARK: - MainUpperViewDelegate

extension MainViewController: MainUpperViewDelegate {
    func backButtonPressed() {
        if presentingTab == .pokedex {
            (tabVCDict[TabType.pokedex] as? PokedexViewController)?.popToRootViewController(animated: true)
        }
        if presentingTab == .gallery {
            (tabVCDict[TabType.gallery] as? GalleryViewController)?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - SamuelOakViewControllerDelegate

extension MainViewController: SamuelOakViewControllerDelegate {
    func finishedDownloading() {
        UIView.animate(withDuration: 0.3, animations: {
            self.samuelOakVC?.view.alpha = 0.0
        }, completion: { _ in
            self.samuelOakVC?.willMove(toParent: nil)
            self.samuelOakVC?.view.removeFromSuperview()
            self.samuelOakVC?.removeFromParent()
            self.samuelOakVC = nil
        })
    }
}
