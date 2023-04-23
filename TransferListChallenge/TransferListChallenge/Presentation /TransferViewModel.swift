//
//  TransferViewModel.swift
//  TransferListChallenge
//
//  Created by Amir Masoumi on 4/21/23.
//

import Foundation

public class TransferViewModel: ObservableObject {
    
    @Published public var transfers: [Transfer] = []
    @Published public var favTransfers: [Transfer] = []
    @Published public var selectedItem: Transfer? = nil
    
    @Published public var isTransfersLoading: Bool = false
    @Published public var isFavTransfersLoading: Bool = false
    
    @Published public var connectivityError : String? = nil
    @Published public var invalidDataError : String? = nil
    @Published public var dataStoreError : String? = nil
    @Published public var deleteError : String? = nil
    @Published public var addError : String? = nil
    
    let transferLoader: TransferLoader
    let favTransferLoader: FavoritesTransferLoader
    let group = DispatchGroup()

    public init(transferLoader: TransferLoader, favTransferLoader: FavoritesTransferLoader) {
        self.transferLoader = transferLoader
        self.favTransferLoader = favTransferLoader
    }
    
    public func load() {
        isTransfersLoading = true
        group.enter()
        transferLoader.load { [weak self] result in
                guard let self = self else { return }
                self.isTransfersLoading = false
                switch result {
                case let .success(transfers):
                    self.transfers = transfers
                case let .failure(error):
                    guard let error = error as? RemoteTransferLoader.Error else { return }
                    switch error {
                    case .connectivity:
                        self.connectivityError = "Please check your network!"
                    case .invalidData:
                        self.invalidDataError = "Could not reach to server!"
                    }
                }
                self.group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.markRemoteTransfersToFavoriteIfNeeded(with: self.favTransfers)
        }

    }
    
    public func loadFavTransfers() {
        isFavTransfersLoading = true
        group.enter()
        favTransferLoader.load { [weak self] result in
                guard let self = self else { return }
                self.isFavTransfersLoading = false
                switch result {
                case let .success(favTransfers):
                    self.favTransfers = favTransfers
                case .failure:
                    self.dataStoreError = "Could not load favorite transfers!"
                    
                }
                self.group.leave()
        }
    }
    
    public func addToFavorites(item: Transfer) {
        favTransferLoader.save(item) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
            case .failure:
                self.addError = "Could not delete item"
            }
        }
    }
    
    public func deleteFavorite(item: Transfer) {
        favTransferLoader.delete(item) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                break
            case .failure:
                self.deleteError = "Could not delete item"
            }
        }
    }
    
    private func markRemoteTransfersToFavoriteIfNeeded(with favTransfers: [Transfer]) {
        favTransfers.forEach { transfer in
            guard let index = transfers.firstIndex(of: transfer) else {  return }
            transfers[index].markedFavorite = true
        }
    }
    
    public func select(item: Transfer) {
        selectedItem = item
    }
}

