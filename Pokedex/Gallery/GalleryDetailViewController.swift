//
//  GalleryDetailViewController.swift
//  Pokedex
//
//  Created by jyj on 8/1/25.
//

import Foundation
import UIKit
import PinLayout

protocol GalleryDetailViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class GalleryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GalleryDetailViewControllerDelegate? = nil
    
    var imageName: String?
    private var resultPokemonNumbers: Array<Int> = []
    
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
        scrollView.addSubview(downloadButton)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let deleteImage = UIImage(systemName: "trash.fill", withConfiguration: configuration)
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.tintColor = .wineRed
        scrollView.addSubview(deleteButton)
        
        starsLabel.text = "★★★☆☆"
        starsLabel.textColor = .wineRed
        starsLabel.font = UIFont(name: "Galmuri11-Bold", size: 40)
        scrollView.addSubview(starsLabel)
        
        xpLabel.text = "450xp"
        xpLabel.textColor = .wineRed
        xpLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        xpLabel.textAlignment = .right
        scrollView.addSubview(xpLabel)
        
        capturedPokemonsLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        capturedPokemonsLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        capturedPokemonsLabel.text = "잡은 포켓몬"
        scrollView.addSubview(capturedPokemonsLabel)
        
        scrollView.addSubview(pokemonContaierView)
        
        for idx in 0..<resultPokemonNumbers.count {
            let view = CapturedPokemonView()
            view.setPokemonInfo(pokedexNumber: resultPokemonNumbers[idx])
            pokemonViews.append(view)
            pokemonContaierView.addSubview(view)
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
