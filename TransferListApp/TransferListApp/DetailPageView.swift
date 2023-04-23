//
//  DetailPageView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import SwiftUI
import TransferListChallenge

struct DetailPageView: View {
    @ObservedObject var viewModel: TransferViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            headerView
            card(number: "12345678", type: "MasterCard")
            moreInfoView
            addToFavButton
        }
    }
    var moreInfoView: some View {
        VStack {
            if let note = viewModel.selectedItem?.note {
                Text(note)
                    .padding()

            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Number Of transfers: \(viewModel.selectedItem?.moreInfo.numberOfTransfers ?? 0)")
                    Text("Total transfers: \(viewModel.selectedItem?.moreInfo.totalTransfer ?? 0)")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
    }
    var addToFavButton: some View {
        Button {
            guard let item = viewModel.selectedItem else { return }
            if item.markedFavorite {
                viewModel.deleteFavorite(item: item)
            } else {
                viewModel.addToFavorites(item: item)
            }
            viewModel.loadFavTransfers()
            presentationMode.wrappedValue.dismiss()
        }label: {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 50)
                .overlay(
                    Text(buttonText)
                    .foregroundColor(.white)
                )
        }
        .padding()
    }
    
    var buttonText: String {
        guard let item = viewModel.selectedItem else { return "Add To Favorites ⭐️"}
        if item.markedFavorite {
            return "Remove from favorites ⭐️"
        } else {
           return "Add To Favorites ⭐️"
        }
    }
    var headerView: some View {
        VStack (spacing: 10){
            Group {
                if let url = viewModel.selectedItem?.person.avatar {
                    AvatarImage(url: url)
                }else {
                    Circle()
                }
            }
            .frame(width: 100, height: 100)
            
            Text(viewModel.selectedItem?.person.fullName ?? "")
            Text(verbatim:viewModel.selectedItem?.person.email ?? "")
                .foregroundColor(Color.secondary)
                .font(.caption)
        }
    }
    func card(number: String, type: String) -> some View {
        VStack{
            Spacer()
            HStack {
                Text(viewModel.selectedItem?.card.cardType ?? "")
                    .italic()
                Spacer()
                Text("blu")
                    .font(.title)
                    .bold()
            }
        }
        .padding()
        .overlay(cardNumber)
        .background(
            Color.green
            .cornerRadius(20)
        )
        .frame(height: 180)
        .padding()
        .foregroundColor(.white)
    }
    var cardNumber: some View {
        Text(viewModel.selectedItem?.card.cardNumber ?? "")
            .font(.title2)
            .kerning(5)
    }
}

struct DetailPageView_Previews: PreviewProvider {
    static var previews: some View {
        let client = URLSessionHTTPClient()
        let url = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io")!
        let loader = RemoteTransferLoader(baseURL: url, client: client)
        let localFavTransferLoader = LocalFavoritesTransferLoader(store: NullStore())
        DetailPageView(viewModel: TransferViewModel(transferLoader: loader, favTransferLoader: localFavTransferLoader))
    }
}
