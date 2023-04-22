//
//  ContentView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import SwiftUI
import TransferListChallenge
import CoreData

struct HomeView: View {
    @ObservedObject var viewModel: TransferViewModel
    let onDetailTap: ()->()
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
            ForEach(viewModel.transfers, id: \.lastTransfer) { item in
                Button{
                    onDetailTap()
                } label: {
                    transferListCell(url: item.person.avatar, name: item.person.fullName, email: item.person.email)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .ignoresSafeArea()
    }
    func transferListCell(url: URL, name: String, email: String?) -> some View {
        HStack {
            avatarImage(url: url)
            .frame(width: 60, height: 60)
                .clipShape(Circle())
            VStack (alignment: .leading, spacing: 10){
                Text(name)
                    .bold()
                if let email = email {
                    Text(email)
                        .foregroundColor(.secondary)
                }
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
                ForEach(viewModel.favTransfers, id: \.lastTransfer) { item in
                    favoritesCell(url: item.person.avatar, name: item.person.fullName, email: item.person.email)
                }
            }
            .padding(.leading)
        }
    }
   
    func favoritesCell(url: URL, name: String, email: String?) -> some View {
        VStack {
            avatarImage(url: url)
                .frame(width: 60, height: 60)
            Text(name)
                .bold()
            if let email = email {
                Text(email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
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
    func avatarImage(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
            } else if phase.error != nil {
                Color.gray
            } else {
                ProgressView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let client = URLSessionHTTPClient()
        let url = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io/transfer-list/1")!
        let loader = RemoteTransferLoader(url: url, client: client)
        let localFavTransferLoader = LocalFavoritesTransferLoader(store: NullStore())
        HomeView(viewModel: TransferViewModel(transferLoader: loader, favTransferLoader: localFavTransferLoader), onDetailTap: {})
    }
}
