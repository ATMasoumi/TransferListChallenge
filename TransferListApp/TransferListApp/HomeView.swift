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
            ScrollView {
                PullToRefreshView(coordinateSpaceName: "pullToRefresh") {
                    viewModel.refreshPaginationData()
                    viewModel.load()
                }
                LazyVStack {
                    ForEach(viewModel.transfers, id: \.lastTransfer) { item in
                        Button{
                            viewModel.select(item: item)
                            onDetailTap()
                        } label: {
                            transferListCell(url: item.person.avatar, name: item.person.fullName, email: item.person.email, markedFav: item.markedFavorite)
                        }
                        .padding(.horizontal)
                    }
                    Color.clear.frame(height: 1)
                        .onAppear {
                            viewModel.load()
                            viewModel.loadFavTransfers()
                        }
                }
            }
            .coordinateSpace(name: "pullToRefresh")
            .animation(.spring(), value: viewModel.transfers)
            
        
    }
    func transferListCell(url: URL, name: String, email: String?, markedFav: Bool) -> some View {
        HStack {
            AvatarImage(url: url)
                .frame(width: 60, height: 60)
            VStack (alignment: .leading, spacing: 10){
                Text(name)
                    .bold()
                if let email = email {
                    Text(email)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if markedFav {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
    }
    
    var favoritesItems: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.favTransfers, id: \.lastTransfer) { item in
                    Button{
                        viewModel.select(item: item)
                        onDetailTap()
                    } label: {
                        favoritesCell(url: item.person.avatar, name: item.person.fullName, email: item.person.email)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.leading)
        }
    }
    
    func favoritesCell(url: URL, name: String, email: String?) -> some View {
        VStack {
            AvatarImage(url: url)
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let client = URLSessionHTTPClient()
        let url = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io")!
        let loader = RemoteTransferLoader(baseURL: url, client: client)
        let localFavTransferLoader = LocalFavoritesTransferLoader(store: NullStore())
        HomeView(viewModel: TransferViewModel(transferLoader: loader, favTransferLoader: localFavTransferLoader), onDetailTap: {})
    }
}
