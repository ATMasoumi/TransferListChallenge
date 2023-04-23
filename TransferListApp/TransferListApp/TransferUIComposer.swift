//
//  TransferUIComposer.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import SwiftUI
import TransferListChallenge
import CoreData

struct TransferUIComposer: View {
    @State var isDetailActive: Bool = false
    @StateObject var viewModel: TransferViewModel

    
    init?() {
        do {
            let store = try CoreDataFavoritesTransferStore(storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
            
            let client = URLSessionHTTPClient()
            let url = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io")!
            let transferLoader = RemoteTransferLoader(baseURL: url, client: client)
            let favTransferLoader = LocalFavoritesTransferLoader(store: store)
            let transferViewModel = TransferViewModel(transferLoader: transferLoader, favTransferLoader: favTransferLoader)
            _viewModel = StateObject(wrappedValue: transferViewModel)
        } catch {
            return nil
        }
    }
    var body: some View {
        NavigationView {
            ZStack {
                HomeView(viewModel: viewModel) {
                    isDetailActive = true
                }
                NavigationLink(isActive: $isDetailActive, destination: {
                    DetailPageView(viewModel: viewModel)
                }) {}
            }
        }
    }
}

struct TransferUIComposer_Previews: PreviewProvider {
    static var previews: some View {
        TransferUIComposer()
    }
}
