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
    var engName: String = ""
    private var pokemon: PokemonModel? = nil
    
    private let scrollView = UIScrollView()
    private let numberLabel = UILabel()
    private let nameLabel = UILabel()
    private let pokeballImageView = UIImageView()
    private let pokemonImageContainerView = UIView()
    private let pokemonImageView = UIImageView()
    private let typeLabel1 = UILabel()
    private let typeLabel2 = UILabel()
    private let descLabel = UILabel()
    
    private let divView1 = UIView()
    private let tableHeaderView = UIView()
    private let divView2 = UIView()
    private let tableContentView = UIView()
    private let divView3 = UIView()
    
    private let categoryHeaderLabel = UILabel()
    private let heightHeaderLabel = UILabel()
    private let weightHeaderLabel = UILabel()
    
    private let categoryLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    
    private var photos: [Photo] = []
    private let photoTitleLabel = UILabel()
    private let photoImageViewContainer = UIView()
    private let photoImageViews: [UIImageView] = [
        UIImageView(), UIImageView(), UIImageView(), UIImageView()
    ]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        pokemon = Pokedex.shared.getPokemon(engName: engName)
        
        self.view.addSubview(scrollView)
        
        numberLabel.textColor = .wineRed
        numberLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        numberLabel.text = "No. \(String(format: "%04d", pokemon?.pokedexNumber ?? 0))"
        scrollView.addSubview(numberLabel)
        
        nameLabel.textColor = .wineRed
        nameLabel.font = UIFont(name: "Galmuri11-Bold", size: 24)
        nameLabel.text = pokemon?.name
        scrollView.addSubview(nameLabel)
        
        pokeballImageView.image = UIImage(named: "pokeball.big.fill")
        pokeballImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(pokeballImageView)
        
        pokemonImageContainerView.layer.cornerRadius = 4.0
        pokemonImageContainerView.layer.borderWidth = 1.0
        pokemonImageContainerView.layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(pokemonImageContainerView)
        
        let pokedexNumber = pokemon?.pokedexNumber ?? 0
        pokemonImageView.image = UIImage(named: "Pokedex\(String(format: "%03d", pokedexNumber-1))")
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageContainerView.addSubview(pokemonImageView)
        
        typeLabel1.layer.cornerRadius = 4.0
        typeLabel1.layer.masksToBounds = true
        typeLabel1.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel1.text = "타입"
        typeLabel1.textColor = .white
        typeLabel1.textAlignment = .center
        scrollView.addSubview(typeLabel1)
        
        typeLabel2.layer.cornerRadius = 4.0
        typeLabel2.layer.masksToBounds = true
        typeLabel2.font = .systemFont(ofSize: 12.0, weight: .bold)
        typeLabel2.text = "타입"
        typeLabel2.textColor = .white
        typeLabel2.textAlignment = .center
        scrollView.addSubview(typeLabel2)
        
        typeLabel1.isHidden = true
        typeLabel2.isHidden = true
        if (pokemon?.type.count ?? 0) >= 1 {
            typeLabel1.text = pokemon?.type[0].rawValue
            typeLabel1.backgroundColor = pokemon?.type[0].color
            typeLabel1.isHidden = false
        }
        if (pokemon?.type.count ?? 0) >= 2 {
            typeLabel2.text = pokemon?.type[1].rawValue
            typeLabel2.backgroundColor = pokemon?.type[1].color
            typeLabel2.isHidden = false
        }
        
        descLabel.text = pokemon?.desc
        descLabel.font = .systemFont(ofSize: 16)
        descLabel.numberOfLines = 0
        descLabel.lineBreakStrategy = .hangulWordPriority
        descLabel.lineBreakMode = .byWordWrapping
        scrollView.addSubview(descLabel)
        
        divView1.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(divView1)
        
        divView2.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(divView2)
        
        divView3.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        scrollView.addSubview(divView3)
        
        tableHeaderView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        scrollView.addSubview(tableHeaderView)
        
        scrollView.addSubview(tableContentView)
        
        categoryHeaderLabel.text = "분류"
        categoryHeaderLabel.textAlignment = .center
        categoryHeaderLabel.font = .systemFont(ofSize: 16)
        categoryHeaderLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        tableHeaderView.addSubview(categoryHeaderLabel)
        
        heightHeaderLabel.text = "키"
        heightHeaderLabel.textAlignment = .center
        heightHeaderLabel.font = .systemFont(ofSize: 16)
        heightHeaderLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        tableHeaderView.addSubview(heightHeaderLabel)
        
        weightHeaderLabel.text = "몸무게"
        weightHeaderLabel.textAlignment = .center
        weightHeaderLabel.font = .systemFont(ofSize: 16)
        weightHeaderLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        tableHeaderView.addSubview(weightHeaderLabel)
        
        categoryLabel.text = pokemon?.category
        categoryLabel.textAlignment = .center
        categoryLabel.font = .systemFont(ofSize: 16)
        tableContentView.addSubview(categoryLabel)
        
        heightLabel.text = pokemon?.height
        heightLabel.textAlignment = .center
        heightLabel.font = .systemFont(ofSize: 16)
        tableContentView.addSubview(heightLabel)
        
        weightLabel.text = pokemon?.weight
        weightLabel.textAlignment = .center
        weightLabel.font = .systemFont(ofSize: 16)
        tableContentView.addSubview(weightLabel)
        
        photoTitleLabel.text = "발견 장소"
        photoTitleLabel.font = .systemFont(ofSize: 16)
        photoTitleLabel.textColor = UIColor(red: 162.0/255.0, green: 162.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        scrollView.addSubview(photoTitleLabel)
        
        photos = CoreDataManager.shared.getPhotos()
        
        scrollView.addSubview(photoImageViewContainer)
        
        for idx in 0..<photoImageViews.count {
            photoImageViews[idx].layer.cornerRadius = 4
            photoImageViews[idx].layer.masksToBounds = true
            
            if idx < 2 {
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                   let imageName = photos[idx].name {
                    let thumbnailFileUrl = documentsDirectory.appendingPathComponent(imageName + "_thumbnail", conformingTo: .jpeg)
                    if FileManager.default.fileExists(atPath: thumbnailFileUrl.path) {
                        photoImageViews[idx].image = UIImage(contentsOfFile: thumbnailFileUrl.path)
                        photoImageViews[idx].contentMode = .scaleAspectFill
                    }
                }
            }
            if photoImageViews[idx].image == nil {
                photoImageViews[idx].layer.borderColor = CGColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
                photoImageViews[idx].layer.borderWidth = 1
            }
            photoImageViewContainer.addSubview(photoImageViews[idx])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        pokeballImageView.pin.top(MainUpperView.topInset + 16).right(16).size(32)
        numberLabel.pin.before(of: pokeballImageView, aligned: .top).left(16).marginRight(4).sizeToFit(.width)
        nameLabel.pin.below(of: numberLabel, aligned: .right).left(16).marginTop(4).sizeToFit(.width)
        pokemonImageContainerView.pin.below(of: nameLabel).horizontally(16).marginTop(16).height(274)
        pokemonImageView.pin.center().size(250)
        typeLabel1.pin.below(of: pokemonImageContainerView).left(16).width(52).height(22).marginTop(24)
        typeLabel2.pin.after(of: typeLabel1, aligned: .center).width(52).height(22).marginLeft(4)
        descLabel.pin.below(of: typeLabel1).horizontally(16).marginTop(12).sizeToFit(.width)
        
        let colWidth: CGFloat = 76
        let colPadding: CGFloat = 2
        divView1.pin.below(of: descLabel).horizontally(16).height(1).marginTop(24)
        tableHeaderView.pin.below(of: divView1).horizontally(16).height(27)
        divView2.pin.below(of: tableHeaderView).horizontally(16).height(1)
        weightHeaderLabel.pin.right(colPadding).vertically().width(colWidth)
        heightHeaderLabel.pin.before(of: weightHeaderLabel).vertically().width(colWidth).marginRight(colPadding*2)
        categoryHeaderLabel.pin.before(of: heightHeaderLabel).left(colPadding).vertically().marginRight(colPadding*2)
        tableContentView.pin.below(of: divView2).horizontally(16).height(43)
        weightLabel.pin.right(colPadding).vertically().width(colWidth)
        heightLabel.pin.before(of: weightLabel).vertically().width(colWidth).marginRight(colPadding*2)
        categoryLabel.pin.before(of: heightLabel).left(colPadding).vertically().marginRight(colPadding*2)
        divView3.pin.below(of: categoryLabel).horizontally(16).height(1)
        
        photoTitleLabel.pin.below(of: divView3).horizontally(16).marginTop(24).sizeToFit(.width)
        photoImageViewContainer.pin.below(of: photoTitleLabel).horizontally(16).marginTop(12)
        let imageGap: CGFloat = 12
        let containerWidth = photoImageViewContainer.frame.width
        let photoCount = CGFloat(photoImageViews.count)
        let imageWidth: CGFloat = (containerWidth - (imageGap * (photoCount-1))) / photoCount
        for idx in 0..<photoImageViews.count {
            let x = CGFloat(idx) * (imageWidth + imageGap)
            photoImageViews[idx].pin.left(x).top().size(imageWidth)
        }
        photoImageViewContainer.pin.below(of: photoTitleLabel).hCenter().marginTop(12).wrapContent()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width,
                                        height: photoImageViewContainer.frame.maxY + 24)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.setBackButton(hidden: true)
    }

}
