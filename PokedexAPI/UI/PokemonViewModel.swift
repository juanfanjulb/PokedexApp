//
//  PokemonViewModel.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation
import CoreData

class PokemonViewModel: ObservableObject {
    let requestHandler = RequestsHandler()
    
    @Published var pokemonData: [Pokemon] = []
    
    
    @Published var namesAndUrls: [String: String] = [:]
    let context = PersistenceController.shared.getViewContext()
    
    init() {
        fetchPokemonsFromCoreData(context: context)
    }
    
    func getInitialPokemonData() async {
        let requestData = await requestHandler.getPokemonUrls()
        
        switch requestData {
        case .success(let data):
            
            for result in data.results {
                DispatchQueue.main.async {
                    self.namesAndUrls[result.name] = result.url
                    // call method to check if the pokemon name is stored, if it is the delete the pokemon and replace it with neew data
                    
                }
            }
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func fetchPokemonInfo() async {
        //let context = PersistenceController.shared.getViewContext()
        for object in namesAndUrls {
            print(object.key)
            print(object.value)
            let requestData = await requestHandler.getPokemonData(pokemonName: object.key)
            
            switch requestData {
            case .success(let pokemon):
                print("YAY")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        fetchPokemonsFromCoreData(context: context)
    }
    
    func fetchPokemonsFromCoreData(context: NSManagedObjectContext) {
        if let allPokemon = Pokemon.getAll(passedContext: context) {
            for pokemon in allPokemon {
                DispatchQueue.main.async {
                    self.pokemonData.append(pokemon)
                    print(pokemon.name)
                }
            }
            
            DispatchQueue.main.async {
                self.pokemonData = self.pokemonData.sorted(by: { $0.id < $1.id })
            }
            
        } else {
            print("ERROR: unable to fetch one or more pokemon from core data")
        }
    }
}
