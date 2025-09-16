//
//  GalleryDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 8/1/25.
//

import Foundation
import UIKit
import PinLayout
import Photos

protocol GalleryDetailViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class GalleryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GalleryDetailViewControllerDelegate? = nil
    
    var photo: Photo?
    private var imageName: String?
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let xpTitleLabel = UILabel()
    private let starsLabel = UILabel()
    private let downloadButton = UIButton()
    private let deleteButton = UIButton()
    private let xpLabel = UILabel()
    private let capturedPokemonsLabel = UILabel()
    private let pokemonContaierView = UIView()
    private var pokemonViews: Array<CapturedPokemonView> = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        
        imageName = photo?.name
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let imageName = imageName {
            let fileUrl = documentsDirectory.appendingPathComponent(imageName, conformingTo: .jpeg)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                imageView.image = UIImage(contentsOfFile: fileUrl.path)
            }
        }
        imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
        
        xpTitleLabel.text = "획득 경험치"
        xpTitleLabel.textColor = .wineRed
        xpTitleLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        scrollView.addSubview(xpTitleLabel)
        
        downloadButton.setImage(UIImage(named: "download"), for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed(_:)), for: .touchUpInside)
        scrollView.addSubview(downloadButton)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let deleteImage = UIImage(systemName: "trash.fill", withConfiguration: configuration)
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.tintColor = .wineRed
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        scrollView.addSubview(deleteButton)
        
        var starArray: [Character] = ["☆", "☆", "☆", "☆", "☆"]
        let photoScore = Int(photo?.score ?? 0)
        for idx in 0..<starArray.count {
            if idx * 100 < photoScore {
                starArray[idx] = "★"
            }
        }
        starsLabel.text = String(starArray)
        starsLabel.textColor = .wineRed
        starsLabel.font = UIFont(name: "Galmuri11-Bold", size: 40)
        scrollView.addSubview(starsLabel)
        
        xpLabel.text = "\(photoScore)xp"
        xpLabel.textColor = .wineRed
        xpLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        xpLabel.textAlignment = .right
        scrollView.addSubview(xpLabel)
        
        var capturePokemonsSuffix = ""
        if (photo?.pokemons?.count ?? 0) == 0 {
            capturePokemonsSuffix = " (없음)"
        }
        capturedPokemonsLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        capturedPokemonsLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        capturedPokemonsLabel.text = "잡은 포켓몬" + capturePokemonsSuffix
        scrollView.addSubview(capturedPokemonsLabel)
        
        scrollView.addSubview(pokemonContaierView)
        
        if let pokemons = photo?.pokemons {
            for pokemon in pokemons {
                if let pokemon = pokemon as? Pokemon {
                    let view = CapturedPokemonView()
                    view.setPokemonInfo(pokemon: pokemon)
                    pokemonViews.append(view)
                    pokemonContaierView.addSubview(view)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        imageView.pin.top(MainUpperView.topInset + 32).horizontally().aspectRatio()
        xpTitleLabel.pin.below(of: imageView).left(16).marginTop(20).sizeToFit()
        downloadButton.pin.vCenter(to: xpTitleLabel.edge.vCenter).right(16).size(40)
        deleteButton.pin.before(of: downloadButton, aligned: .center).size(40).marginRight(4)
        starsLabel.pin.below(of: xpTitleLabel).left(16).marginTop(8).sizeToFit()
        xpLabel.pin.after(of: starsLabel, aligned: .center).right(16).marginLeft(8).sizeToFit(.width)
        
        capturedPokemonsLabel.pin.below(of: starsLabel).left(16).marginTop(24).sizeToFit()
        pokemonContaierView.pin.below(of: capturedPokemonsLabel).horizontally(16).marginTop(12)
        for idx in 0..<pokemonViews.count {
            let view = pokemonViews[idx]
            let gap: CGFloat = 12.0
            let width: CGFloat = (pokemonContaierView.frame.width-gap)/2.0
            let height: CGFloat = 201.0
            let x: CGFloat = ((idx%2==0) ? 0.0 : width+gap)
            let y = CGFloat(idx/2) * (height+gap)
            view.pin.left(x).top(y).width(width).height(height)
        }
        pokemonContaierView.pin.below(of: capturedPokemonsLabel).left(16).wrapContent().marginTop(12)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: pokemonContaierView.frame.maxY + 16)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.setBackButton(hidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            delegate?.setBackButton(hidden: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.setBackButton(hidden: true)
    }
    
}

// MARK: - Private Extensions

private extension GalleryDetailViewController {
    @objc func deleteButtonPressed(_ sender: UIButton) {
        let alertVC = AlertViewController()
        alertVC.tag = GalleryAlertType.deletePhoto
        alertVC.delegate = self
        alertVC.alertType = .confirm
        alertVC.titleText = "사진 삭제"
        alertVC.contentText = "선택한 사진을 삭제하시겠습니까?"
        self.present(alertVC, animated: true)
    }
    
    @objc func downloadButtonPressed(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self?.downloadPhoto()
                }
                else {
                    let alertVC = AlertViewController()
                    alertVC.tag = GalleryAlertType.goSetting
                    alertVC.alertType = .confirm
                    alertVC.titleText = "앨범 접근 권한"
                    alertVC.contentText = "사진 저장을 위해 앨범 접근 권한이 필요합니다.\n설정 화면으로 이동하시겠습니까?"
                    alertVC.delegate = self
                    self?.present(alertVC, animated: true)
                }
            }
        }
    }
    
    func downloadPhoto() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }, completionHandler: { _, error in
            if let error = error {
                print("Save photo failed: \(error)")
            }
        })
        
        let alertVC = AlertViewController()
        alertVC.tag = GalleryAlertType.downloadFinished
        alertVC.alertType = .alert
        alertVC.titleText = "사진 저장"
        alertVC.contentText = "앨범에 사진이 저장되었습니다."
        self.present(alertVC, animated: true)
    }
    
    func deletePhoto() {
        guard let photo = photo,
              let imageName = photo.name else {
            return
        }
        
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectory.appendingPathComponent(imageName, conformingTo: .jpeg)
        let thumbnailFileUrl = documentsDirectory.appendingPathComponent(imageName + "_thumbnail", conformingTo: .jpeg)
        do {
            try FileManager.default.removeItem(at: fileUrl)
            try FileManager.default.removeItem(at: thumbnailFileUrl)
        } catch {
            print("File manager remove item failed \(error)")
        }
        
        CoreDataManager.shared.deletePhoto(photo: photo) {
            self.navigationController?.popToRootViewController(animated: true)
            if let topVC = self.navigationController?.topViewController as? GalleryCollectionViewController {
                topVC.reloadPhotosFirstTime()
            }
        }
    }
}

// MARK: - AlertViewControllerDelegate  

extension GalleryDetailViewController: AlertViewControllerDelegate {
    func buttonPressed(buttonType: AlertButtonType, tag: Int?) {
        if buttonType == .ok {
            if tag == GalleryAlertType.deletePhoto {
                deletePhoto()
            }
            if tag == GalleryAlertType.goSetting {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
