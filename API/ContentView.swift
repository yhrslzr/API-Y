//
//  ContentView.swift
//  API
//
//  Created by win603 on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var pokemonList = PokemonListViewModel()
    
    var body: some View {
        VStack {
            Text("\(pokemonList.pokemon.count)")
            Text(pokemonList.pokemon.next)
            Text(pokemonList.pokemon.previous ?? "")
            
            List(){
                ForEach(pokemonList.pokemon.results, id: \.self){ pokemon in
                    VStack{
                        Text(pokemon.name)
                        AsyncImage(url: URL(string: pokemon.url)!){ image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                    }
                }
            }
        }
        .padding()
        .onAppear(){
            pokemonList.getPokemonList()
        }
    }
}

#Preview {
    ContentView()
}
