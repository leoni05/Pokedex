//
//  Photo+CoreDataProperties.swift
//  Pokedex
//
//  Created by jyj on 8/17/25.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var captureDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var score: Int16
    @NSManaged public var pokemons: NSOrderedSet?

}

// MARK: Generated accessors for pokemons
extension Photo {

    @objc(insertObject:inPokemonsAtIndex:)
    @NSManaged public func insertIntoPokemons(_ value: Pokemon, at idx: Int)

    @objc(removeObjectFromPokemonsAtIndex:)
    @NSManaged public func removeFromPokemons(at idx: Int)

    @objc(insertPokemons:atIndexes:)
    @NSManaged public func insertIntoPokemons(_ values: [Pokemon], at indexes: NSIndexSet)

    @objc(removePokemonsAtIndexes:)
    @NSManaged public func removeFromPokemons(at indexes: NSIndexSet)

    @objc(replaceObjectInPokemonsAtIndex:withObject:)
    @NSManaged public func replacePokemons(at idx: Int, with value: Pokemon)

    @objc(replacePokemonsAtIndexes:withPokemons:)
    @NSManaged public func replacePokemons(at indexes: NSIndexSet, with values: [Pokemon])

    @objc(addPokemonsObject:)
    @NSManaged public func addToPokemons(_ value: Pokemon)

    @objc(removePokemonsObject:)
    @NSManaged public func removeFromPokemons(_ value: Pokemon)

    @objc(addPokemons:)
    @NSManaged public func addToPokemons(_ values: NSOrderedSet)

    @objc(removePokemons:)
    @NSManaged public func removeFromPokemons(_ values: NSOrderedSet)

}

extension Photo : Identifiable {

}
