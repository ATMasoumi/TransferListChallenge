//
//  PullToRefreshView.swift
//  TransferListApp
//
//  Created by Amir Masoumi on 4/23/23.
//

import SwiftUI

public struct PullToRefreshView: View {
    
    var coordinateSpaceName: String
    public var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    
   public init(coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
    }
    public var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {

                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct PullToRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            PullToRefreshView(coordinateSpaceName: "pullToRefresh") {
                // do your stuff when pulled
            }
            
            Text("Some view...")
        }
        .coordinateSpace(name: "pullToRefresh")
    }
}
