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
    @Published var pokemonDataStatus: status = .none
    
    let context = PersistenceController.shared.getViewContext()
    
    init() {
        fetchPokemonsFromCoreData(context: context)
    }
    
    func getInitialPokemonData() async {
        let requestData = await requestHandler.getPokemonUrls()
        
        pokemonDataStatus = .loading
        
        switch requestData {
        case .success(let data):
            var names: [String] = []
            
            for result in data.results {
                DispatchQueue.main.async {
                    self.namesAndUrls[result.name] = result.url
                }
                
                names.append(result.name)
            }
            
            // If the recent fetched names are existing Pokemon objects in core data, delete them to avoid issues
            if let matchingPokemon = Pokemon.getAllByNames(passedContext: context, pokemonNames: names) {
                DispatchQueue.main.async {
                    self.pokemonData = []
                }
                Pokemon.deleteAll(passedContext: context)
            }
            
            if !namesAndUrls.isEmpty {
                await fetchPokemonInfo()
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            pokemonDataStatus = .none
        }
    }
    
    func fetchPokemonInfo() async {
        //let context = PersistenceController.shared.getViewContext()
        for object in namesAndUrls {
            let requestData = await requestHandler.getPokemonData(pokemonName: object.key)
            
            switch requestData {
            case .success(let pokemon):
                print("successfuly fetched pokemon: \(String(describing: pokemon.name))")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Clean up dictionary for future requests
        namesAndUrls = [:]
        
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
                self.pokemonDataStatus = .complete
            }
            
        } else {
            print("ERROR: unable to fetch one or more pokemon from core data")
            self.pokemonDataStatus = .none
        }
    }
}

public enum status {
    case none
    case loading
    case complete
}
