//
//  PokemonModel.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation
import UIKit

enum PokemonType: String {
    case normal
    case fire
    case water
    case grass
    case electric
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    var koreanText: String {
        switch self {
        case .normal:
            return "노말"
        case .fire:
            return "불꽃"
        case .water:
            return "물"
        case .grass:
            return "풀"
        case .electric:
            return "전기"
        case .ice:
            return "얼음"
        case .fighting:
            return "격투"
        case .poison:
            return "독"
        case .ground:
            return "땅"
        case .flying:
            return "비행"
        case .psychic:
            return "에스퍼"
        case .bug:
            return "벌레"
        case .rock:
            return "바위"
        case .ghost:
            return "고스트"
        case .dragon:
            return "드래곤"
        case .dark:
            return "악"
        case .steel:
            return "강철"
        case .fairy:
            return "페어리"
        }
    }
    
    var color: UIColor {
        switch self {
        case .normal:
            return UIColor(red: 148.0/255.0, green: 148.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        case .fire:
            return UIColor(red: 229.0/255.0, green: 108.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        case .water:
            return UIColor(red: 81.0/255.0, green: 133.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        case .grass:
            return UIColor(red: 102.0/255.0, green: 169.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        case .electric:
            return UIColor(red: 251.0/255.0, green: 185.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        case .ice:
            return UIColor(red: 109.0/255.0, green: 200.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        case .fighting:
            return UIColor(red: 224.0/255.0, green: 156.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        case .poison:
            return UIColor(red: 115.0/255.0, green: 81.0/255.0, blue: 152.0/255.0, alpha: 1.0)
        case .ground:
            return UIColor(red: 156.0/255.0, green: 119.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        case .flying:
            return UIColor(red: 162.0/255.0, green: 195.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        case .psychic:
            return UIColor(red: 221.0/255.0, green: 107.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        case .bug:
            return UIColor(red: 159.0/255.0, green: 162.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        case .rock:
            return UIColor(red: 191.0/255.0, green: 184.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        case .ghost:
            return UIColor(red: 104.0/255.0, green: 72.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        case .dragon:
            return UIColor(red: 83.0/255.0, green: 92.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 76.0/255.0, green: 73.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        case .steel:
            return UIColor(red: 105.0/255.0, green: 169.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        case .fairy:
            return UIColor(red: 218.0/255.0, green: 180.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
    }
}

struct PokemonModel {
    let name: String
    let type: Array<PokemonType>
    let height: String
    let weight: String
    let category: String
    let desc: String
    let engName: String
    var pokedexNumber: Int = 0
    var capturedDate: String = "미포획"
    var selected: Bool = false
}

struct PokeapiInfoModel: Decodable {
    struct PokeapiTypeModel: Decodable {
        struct PokeapiTypeDetailModel: Decodable {
            let name: String
        }
        let type: PokeapiTypeDetailModel
    }
    let weight: Int
    let height: Int
    let types: Array<PokeapiTypeModel>
}
