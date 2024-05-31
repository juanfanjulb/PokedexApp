//
//  Pokemon+CoreDataProperties.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 29/05/2024.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var types: [String]?
    @NSManaged public var sprite: String?
    @NSManaged public var hp: Int16
    @NSManaged public var attack: Int16
    @NSManaged public var defense: Int16
    @NSManaged public var favourite: Bool

}

extension Pokemon : Identifiable {

}
