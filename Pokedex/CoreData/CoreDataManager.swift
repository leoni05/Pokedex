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
    var context: NSManagedObjectContext? = nil
    
    private init() { }
    
    func getPhotos() -> [Photo] {
        var photos: [Photo] = []
        if let context = context {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photo")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "captureDate", ascending: false)
            ]
            do {
                if let fetchResult = try context.fetch(fetchRequest) as? [Photo] {
                    photos = fetchResult
                }
            }
            catch {
                print("Fetch failed: \(error)")
            }
        }
        return photos
    }
    
    func savePhoto(captureDate: Date, name: String, resultString: String, completion: @escaping () -> Void) {
        if let context = context,
           let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context),
           let photo = NSManagedObject(entity: entity, insertInto: context) as? Photo {
            photo.captureDate = captureDate
            photo.name = name
            photo.resultString = resultString
            do {
                try context.save()
                completion()
            }
            catch {
                print("Save failed: \(error)")
            }
        }
    }
    
}
