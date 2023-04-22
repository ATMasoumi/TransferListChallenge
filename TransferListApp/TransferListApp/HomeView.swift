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
            title(name: "Favorites")
            favoritesItems
            title(name: "All")
            transferList
        }
    }
    
    var transferList: some View {
        List {
            ForEach(1...10, id: \.self) { item in
                transferListCell(url: "", title: "name ", subTitle: "subtitle")
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .ignoresSafeArea()
    }
    func transferListCell(url: String, title: String, subTitle: String) -> some View {
        HStack {
            Circle()
                .frame(width: 60, height: 60)
            VStack (alignment: .leading, spacing: 10){
                Text(title)
                    .bold()
                Text(subTitle)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Image(systemName: "chevron.right")
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
    }
    
    var favoritesItems: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(1...5, id: \.self) { item in
                    favoritesCell(url: "", title: "name ", subTitle: "subtitle")
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
  
    func title(name: String) -> some View {
        HStack {
            Text(name)
                .font(.title)
                .bold()
            Spacer()
        }
        .padding(.leading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
