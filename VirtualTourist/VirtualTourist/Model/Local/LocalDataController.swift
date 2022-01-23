//
//  LocalDataController.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import CoreData

class DataController {

    static let shared = DataController(modelName: "VirtualTourist")
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load(_ completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else { fatalError(error?.localizedDescription ?? "") }
            completion?()
        }
    }
}
