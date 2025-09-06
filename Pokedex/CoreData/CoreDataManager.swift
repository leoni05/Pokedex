//
//  CoreDataManager.swift
//  Pokedex
//
//  Created by jyj on 7/26/25.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager() 
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    private init() { }
    
    func getPhotos() -> [Photo] {
        var photos: [Photo] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photo")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "captureDate", ascending: false)
        ]
        do {
            if let fetchResult = try persistentContainer.viewContext.fetch(fetchRequest) as? [Photo] {
                photos = fetchResult
            }
        }
        catch {
            print("Fetch failed: \(error)")
        }
        return photos
    }
    
    func savePhoto(captureDate: Date, name: String, gotchaResult: GotchaResult, completion: () -> Void) {
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: persistentContainer.viewContext),
           let photo = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Photo {
            photo.captureDate = captureDate
            photo.name = name
            photo.score = Int16(gotchaResult.resultScore)
            for pokedexNumber in gotchaResult.resultPokemonNumbers {
                photo.addToPokemons(Pokedex.shared.pokemons[pokedexNumber-1])
                if Pokedex.shared.pokemons[pokedexNumber-1].captureDate == nil {
                    Pokedex.shared.pokemons[pokedexNumber-1].captureDate = Date()
                }
            }
            do {
                try persistentContainer.viewContext.save()
                completion()
            }
            catch {
                print("Save failed: \(error)")
            }
        }
    }
    
    func deletePhoto(photo: Photo, completion: () -> Void) {
        do {
            persistentContainer.viewContext.delete(photo)
            try persistentContainer.viewContext.save()
            completion()
        }
        catch {
            print("Delete failed: \(error)")
        }
    }
    
    func getPokemons() -> [Pokemon] {
        var pokemons: [Pokemon] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "pokedexNumber", ascending: true)
        ]
        do {
            if let fetchResult = try persistentContainer.viewContext.fetch(fetchRequest) as? [Pokemon] {
                pokemons = fetchResult
            }
        }
        catch {
            print("Fetch failed: \(error)")
        }
        return pokemons
    }
    
    func savePokemon(number: Int, pokemonInfo: PokeapiInfoModel, pokemonSpecie: PokeapiSpeciesModel) throws {
        if let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: persistentContainer.viewContext),
           let pokemon = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Pokemon {
            var typeString = ""
            for typeElement in pokemonInfo.types {
                if typeString.count > 0 {
                    typeString += ","
                }
                typeString += typeElement.type.name
            }
            pokemon.pokedexNumber = Int16(number)
            pokemon.type = typeString
            pokemon.height = Int16(pokemonInfo.height)
            pokemon.weight = Int16(pokemonInfo.weight)
            if let genusElement = pokemonSpecie.genera.first(where: { $0.language.name == "ko" }) {
                pokemon.category = genusElement.genus
            }
            if let descElement = pokemonSpecie.flavor_text_entries.first(where: { $0.language.name == "ko" }) {
                pokemon.desc = descElement.flavor_text.replacingOccurrences(of: "\n", with: " ")
            }
            if let nameElement = pokemonSpecie.names.first(where: { $0.language.name == "ko" }) {
                pokemon.name = nameElement.name
            }
            
            do {
                try persistentContainer.viewContext.save()
            }
            catch {
                print("Save failed: \(error)")
                throw error
            }
        }
    }
    
}
