//
//  Persistence.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import CoreData

class PersistenceController {
    static private(set) var shared = PersistenceController()
    let container = NSPersistentContainer(name: "PokedexAPI")
    
    /// Global instance of NSPersistentContainer
    var persistentContainer: NSPersistentContainer?

    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        let samplePokemon = Pokemon(context: viewContext)
        samplePokemon.id = 1
        samplePokemon.name = "bulbasaur"
        samplePokemon.types = ["grass", "poison"]
        samplePokemon.hp = 45
        samplePokemon.attack = 49
        samplePokemon.defense = 49
        samplePokemon.favourite = false
        samplePokemon.sprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    
    init(inMemory: Bool = false) {
        //container = NSPersistentContainer(name: "something")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.persistentContainer = container
        print("Successfully initialized NSPersistentContainer.")
    }
    
    /// Initializes the persistent store
    func loadStore() {
        container.loadPersistentStores(completionHandler: {(_, error) in
            if let error = error as NSError? {
                // if the store is unable to load, call fatal error to kill the app
                fatalError("Error while initializing NSPersistentContainer. \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer = container
        print("Successfully initialized NSPersistentContainer.")
    }
    
    // MARK: - Helper methods to save and create objects.
    /// Saves viewContext. Call this  method only when handling changes in the main thread.
    func save() {
        guard Thread.isMainThread else {
            print("Attempted to save the viewContext from a background thread is NOT allowed. " +
                  "Create a background context and produce changes there.")
            return
        }
        
        if getViewContext().hasChanges {
            getViewContext().saveAndThrow()
        }
    }
    
    /// If the context is not available by the time some entity calls this function, fatalError is called.
    func getViewContext() -> NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else {
            fatalError("Attempted to access Core Data without loading the persistent store.")
        }
        
        return context
    }
    
    /// Returns a new context with the concurrencyType set to NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType.
    /// Use this context to make changes in Core Data from a background thread. For more info check https://developer.apple.com/documentation/coredata/using_core_data_in_the_background
    func getBackgroundContext() -> NSManagedObjectContext {
        guard let context = persistentContainer?.newBackgroundContext(), !Thread.isMainThread else {
            fatalError("Unable to create background context. Error is due to being in the main thread: \(Thread.isMainThread)")
        }
        
        return context
    }
}

// MARK: - NSManagedObjectContext extension.
extension NSManagedObjectContext {
    
    /// Calls NSManagedObjectContext save() method but handles error throwing and logging.
    /// Use this method inside a block where a background context was created.
    func saveAndThrow() {
        self.performAndWait {
            if self.hasChanges {
                do {
                    try save()
                    print("Successfully saved context in thread")
                } catch {
                    print("Unable to save context in thread")
                }
            }
        }
    }
}
