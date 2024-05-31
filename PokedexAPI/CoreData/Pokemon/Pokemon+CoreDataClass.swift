//
//  Pokemon+CoreDataClass.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 29/05/2024.
//
//

import Foundation
import CoreData

@objc(Pokemon)
public class Pokemon: NSManagedObject, Codable {

    /// The properties of the Pokemon object are decoded from the JSON using the decoder and the keys specified in the CodingKeys enumerations
    enum CodingKeys: CodingKey {
        case id, name, types, attack , hp, defense, sprite, stats, sprites
        
        /// Special handling is done to decode the types, stats, and sprite properties, which are nested in the JSON.
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
        }
    }
    
    ///Iinitialize a Pokemon object from data decoded from a JSON
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.privateContextKey] as? NSManagedObjectContext else {
            print("Unable to get background context from decoder")
            fatalError("Unable to get background context from decoder.")
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(context: context)
        
        self.id = try container.decodeIfPresent(Int16.self, forKey: .id) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        
        /// MARK: Types
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        // Loop through all the type objects in the array
        var decodedTypes: [String] = []
        while !typesContainer.isAtEnd {
            // Loop through type info
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        
        self.types = decodedTypes
        
        /// MARK: Stats
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            // Loop through stat info
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int16.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int16.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int16.self, forKey: .value)
            default:
                break
            }
        }
        
        /// MARK: Sprite
        let spritesContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spritesContainer.decode(String.self, forKey: .sprite)
        
        self.favourite = false
    }
    
    /// Must be incorporated to be able to conform to Codable
    public func encode(to encoder: Encoder) throws {}
    
    static func create(passedContext: NSManagedObjectContext? = nil) -> Pokemon {
        let context = passedContext ?? PersistenceController.shared.getViewContext()
        return Pokemon(context: context)
    }
    
    static func save(passedContext: NSManagedObjectContext? = nil, pokemon: Pokemon?) {
        let context = passedContext ?? PersistenceController.shared.getViewContext()
        let coreDataPokemon = Pokemon(context: context)
        
        coreDataPokemon.id = pokemon?.id ?? -1
        coreDataPokemon.name = pokemon?.name ?? ""
        coreDataPokemon.types = pokemon?.types ?? []
        coreDataPokemon.sprite = pokemon?.sprite ?? ""
        coreDataPokemon.hp = pokemon?.hp ?? -1
        coreDataPokemon.attack = pokemon?.attack ?? -1
        coreDataPokemon.defense = pokemon?.defense ?? -1
        coreDataPokemon.favourite = false
        
        context.saveAndThrow()
    }
    
    /// Fetched and returns all Pokemon objects with the passed context or the viewContext if nil.
    static func getAll(passedContext: NSManagedObjectContext? = nil) -> [Pokemon]? {
        let context = passedContext ?? PersistenceController.shared.getViewContext()
        
        return context.performAndWait {
            do {
                let fetchResults = try context.fetch(self.fetchRequest())
                // Return result.
                return fetchResults
                
            } catch let error {
                print("Unable to fetch userFormSettings from Core Data.", error.localizedDescription)
                return nil
            }
        }
    }
}


// MARK: - CodingUserInfoKey extension
extension CodingUserInfoKey {
    
    /// Holds the userInfo key to pass on a background NSManagedObjectContext onto a JSONDecoder instance.
    static let privateContextKey: CodingUserInfoKey = {
        guard let key = CodingUserInfoKey(rawValue: "privateContext") else {
            print("Unable to get background context from decoder")
            fatalError("Unable to get privateContextKey")
        }
        
        return key
    }()
}
