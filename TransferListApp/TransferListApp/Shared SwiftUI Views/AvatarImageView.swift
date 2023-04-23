//
//  AvatarImageView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/23/23.
//

import SwiftUI
import Kingfisher

struct AvatarImage: View {
    let url: URL
    var body: some View {
        KFImage.url(url)
                  .loadDiskFileSynchronously()
                  .placeholder {
                      ProgressView()
                  }
                  .cacheMemoryOnly()
                  .fade(duration: 0.25)
                  .onSuccess { result in  }
                  .onFailure { error in }
                  .resizable()
                  .cancelOnDisappear(true)
                  .clipShape(Circle())
    }
}
struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImage(url: URL(string: "any-url.com")!)
    }
}
