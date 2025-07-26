//
//  Photo+CoreDataProperties.swift
//  Pokedex
//
//  Created by jyj on 7/26/25.
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
    @NSManaged public var resultString: String?

}

extension Photo : Identifiable {

}
