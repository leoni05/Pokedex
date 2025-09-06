//
//  Pokedex.swift
//  Pokedex
//
//  Created by leoni05 on 6/7/25.
//

import Foundation

class Pokedex {
    
    // MARK: - Properties
    
    static let totalNumber = 10
    static let shared = Pokedex()
    private var todayPokemonNumbers: Set<Int> = []
    var pokemons = [Pokemon]()
    var listedPokemons = [Pokemon]()
    var capturedCount = 0

    // MARK: - Life Cycle
    
    private init() {
        guard let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else {
            return
        }
        srand48(Int(date.timeIntervalSince1970))
        for _ in 0..<10 {
            let randomNumber = Int(drand48() * Double(Pokedex.totalNumber)) + 1
            todayPokemonNumbers.insert(randomNumber)
        }
    }
    
}

// MARK: - Extensions

extension Pokedex {
    func reloadPokemon() {
        pokemons = CoreDataManager.shared.getPokemons()
        setListedPokemons()
    }
    
    func setListedPokemons() {
        listedPokemons = []
        capturedCount = 0
        for pokemon in pokemons {
            if pokemon.captureDate != nil {
                listedPokemons.append(pokemon)
                capturedCount += 1
            }
            else if todayPokemonNumbers.contains(Int(pokemon.pokedexNumber)) {
                listedPokemons.append(pokemon)
            }
        }
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
