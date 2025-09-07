//
//  SelectPokemonViewController.swift
//  Pokedex
//
//  Created by jyj on 9/7/25.
//

import Foundation
import UIKit
import PinLayout

protocol SelectPokemonViewControllerDelegate: AnyObject {
    func setBackButton(hidden: Bool)
}

class SelectPokemonViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SelectPokemonViewControllerDelegate? = nil
    var targetIndex: Int? = nil
    
    private let horizontalInset = 16.0
    private let itemSpacing = 12.0
    private let itemHeight: CGFloat = 253.0
    
    private var collectionView: UICollectionView? = nil
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private let clearButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(indicatorView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: MainUpperView.topInset + 16.0, left: horizontalInset,
                                           bottom: 16.0 + 52.0 + 16.0, right: horizontalInset)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: PokedexCell.reuseIdentifier)
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
        
        clearButton.layer.borderWidth = 2.0
        clearButton.layer.borderColor = UIColor.wineRed.cgColor
        clearButton.backgroundColor = .white
        clearButton.setTitle("해제", for: .normal)
        clearButton.setTitleColor(.wineRed, for: .normal)
        clearButton.titleLabel?.font = UIFont(name: "Galmuri11-Bold", size: 24)
        clearButton.addTarget(self, action: #selector(clearButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(clearButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        indicatorView.pin.all()
        collectionView?.pin.all()
        clearButton.pin.bottom(16).right(16).width(68).height(52)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        collectionView?.isHidden = true
        DispatchQueue.main.async {
            Pokedex.shared.reloadPokemon()
            self.indicatorView.isHidden = true
            self.indicatorView.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.alpha = 0.0
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1.0
            }
        }
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

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - horizontalInset*2 - itemSpacing) / 2.0
        return CGSize(width: width, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDataSource

extension SelectPokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pokedex.shared.listedPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCell.reuseIdentifier, for: indexPath)
        if let cell = reusableCell as? PokedexCell {
            let pokemonNumber = Pokedex.shared.listedPokemons[indexPath.row].pokedexNumber
            cell.setPokemonInfo(index: Int(pokemonNumber-1))
        }
        return reusableCell
    }
}

// MARK: - Private Extensions

private extension SelectPokemonViewController {
    @objc func clearButtonPressed(_ sender: UIButton) {
        let alertVC = AlertViewController()
        alertVC.alertType = .confirm
        alertVC.titleText = "대표 포켓몬 해제"
        alertVC.contentText = "대표 포켓몬을 해제할까요?"
        alertVC.delegate = self
        self.present(alertVC, animated: true)
    }
}

// MARK: - AlertViewControllerDelegate

extension SelectPokemonViewController: AlertViewControllerDelegate {
    func buttonPressed(buttonType: AlertButtonType) {
        if buttonType == .ok {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
