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
            Text("Note:Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.")
                .padding()
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Number Of transfers: 81")
                    Text("Total transfers: 349890")
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
            
        }label: {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 50)
                .overlay {
                    Text("Add to favorites ⭐️")
                        .foregroundColor(.white)
                }
        }
        .padding()
    }
    var headerView: some View {
        VStack (spacing: 10){
            Circle()
                .frame(width: 100, height: 100)
            Text("Amin")
            Text(verbatim:"Torabi.dsd@gmail.com")
                .foregroundColor(Color.secondary)
                .font(.caption)
        }
    }
    func card(number: String, type: String) -> some View {
        VStack{
            Spacer()
            HStack {
                Text(type)
                    .italic()
                Spacer()
                Text("Blu")
                    .font(.title)
                    .bold()
            }
        }
        .padding()
        .overlay {
            Text("12345667909")
                .font(.title2)
                .kerning(5)
        }
        .background {
            Color.green
                .cornerRadius(20)
        }
        .frame(height: 180)

        .padding()
        .foregroundColor(.white)
    }
}

struct DetailPageView_Previews: PreviewProvider {
    static var previews: some View {
        let client = URLSessionHTTPClient()
        let url = URL(string: "https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io/transfer-list/1")!
        let loader = RemoteTransferLoader(url: url, client: client)
        let localFavTransferLoader = LocalFavoritesTransferLoader(store: NullStore())
        DetailPageView(viewModel: TransferViewModel(transferLoader: loader, favTransferLoader: localFavTransferLoader))
    }
}
