//
//  GotchaModel.swift
//  Pokedex
//
//  Created by jyj on 9/6/25.
//

import Foundation

struct GotchaResult {
    var resultScore: Int = 0
    var resultPokemonNumbers: Array<Int> = []
    var pokemonNumberSet: Set<Int> = []
}

enum GotchaError: Error {
    case imageGenerate
    case documentsDirectory
    case firebaseUpload
}
