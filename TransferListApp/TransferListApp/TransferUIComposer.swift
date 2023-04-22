//
//  TransferUIComposer.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/22/23.
//

import SwiftUI
import TransferListChallenge

struct TransferUIComposer: View {
    @State var isDetailActive: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                HomeView() {
                    isDetailActive = true
                }
                NavigationLink(isActive: $isDetailActive, destination: {
                    DetailPageView()
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
