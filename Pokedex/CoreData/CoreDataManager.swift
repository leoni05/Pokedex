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
    
    func savePhoto(captureDate: Date, name: String, resultString: String, completion: @escaping () -> Void) {
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: persistentContainer.viewContext),
           let photo = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as? Photo {
            photo.captureDate = captureDate
            photo.name = name
            do {
                try persistentContainer.viewContext.save()
                completion()
            }
            catch {
                print("Save failed: \(error)")
            }
        }
    }
    
}
