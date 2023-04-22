//
//  ContentView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            favoritesTitle
            favoritesItems
            Spacer()
        }
    }
    
    
    var favoritesItems: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(1...5, id: \.self) { item in
                    favoritesCell(url: "", title: "\(item) name ", subTitle: "\(item)")
                }
            }
            .padding(.leading)
        }
    }
   
    func favoritesCell(url: String, title: String, subTitle: String) -> some View {
        VStack {
            Circle()
                .frame(width: 60, height: 60)
            Text(title)
                .bold()
            Text(subTitle)
                .foregroundColor(.secondary)
        }
        .padding()
    }
  
    var favoritesTitle: some View {
        HStack {
            Text("Favorites")
                .font(.largeTitle)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
