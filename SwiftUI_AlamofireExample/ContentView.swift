//
//  ContentView.swift
//  SwiftUI_AlamofireExample
//
//  Created by cano on 2023/05/12.
//

import SwiftUI
import Combine
import Alamofire

import SwiftUI
import Combine

struct ContentView: View {
    // @ObservedObject: 画面に入る時、初期化されない。 上位ページによって初期化される。
    // @StateObject: 画面に入る時、初期化される。　上位ページによって初期化されない。
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.result, id: \.idDrink) { cocktail in
                CocktailSearchRowView(cocktail: cocktail)
            }
            .overlay {
                if viewModel.isSearching {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Search Cacktail Combine")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $viewModel.searchWord)
        
        /*
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            /*if let decodedData = viewModel.decodedData {
                Text("\(decodedData.drinks.count)")
            }*/
        }
        .padding()
        */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
