//
//  ContentView.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    @ObservedObject var viewModel: PokemonViewModel
    
    init() {
        // Initialize Core Data on app launch.
        PersistenceController.shared.loadStore()
        
        viewModel = PokemonViewModel()
    }

    var body: some View {
        ZStack {
            VStack {
                if !viewModel.pokemonData.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.pokemonData.indices, id: \.self) { index in
                                let pokemon = viewModel.pokemonData[index]
                                
                                Text(String(pokemon.id))
                                Text(pokemon.name ?? "")
                            }
                        }
                    }
                } else {
                    ProgressView("Loading Pokémon...")
                }
                
                Button(action: {
                    Task {
                        await viewModel.getInitialPokemonData()
                    }
                    //viewModel
                }, label: {
                    Text("Button")
                })
                
                if !viewModel.namesAndUrls.isEmpty {
                    Button(action: {
                        Task {
                            await viewModel.fetchPokemonInfo()
                        }
                    }, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
