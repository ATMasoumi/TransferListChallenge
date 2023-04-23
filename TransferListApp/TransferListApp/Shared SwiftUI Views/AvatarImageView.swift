//
//  AvatarImageView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/23/23.
//

import SwiftUI

struct AvatarImage: View {
    let url: URL
    var body: some View {
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
            .clipShape(Circle())
    }
}
struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImage(url: URL(string: "any-url.com")!)
    }
}
