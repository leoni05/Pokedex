//
//  Pokedex.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation

class Pokedex {
    
    // MARK: - Properties
    
    static let totalNumber = 3
    static let shared = Pokedex()
    var pokemons = [Pokemon]()

    // MARK: - Life Cycle
    
    private init() { }
    
}

// MARK: - Extensions

extension Pokedex {
    func getPokemon(engName: String) -> Pokemon? {
        return nil
    }
    
    func reloadPokemon() {
        pokemons = CoreDataManager.shared.getPokemons()
    }
    
    func getPokemonInfoFromAPI(number: Int) async -> PokeapiInfoModel? {
        guard let apiURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)") else {
            return nil
        }
        let request = URLRequest(url: apiURL)
        if let (data, _) = try? await URLSession.shared.data(for: request),
           let info = try? JSONDecoder().decode(PokeapiInfoModel.self, from: data) {
            return info
        }
        return nil
    }
    
    func getPokemonSpeciesFromAPI(number: Int) async -> PokeapiSpeciesModel? {
        guard let apiURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(number)") else {
            return nil
        }
        let request = URLRequest(url: apiURL)
        if let (data, _) = try? await URLSession.shared.data(for: request),
           let info = try? JSONDecoder().decode(PokeapiSpeciesModel.self, from: data) {
            return info
        }
        return nil
    }
}
