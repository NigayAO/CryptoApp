//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Alik Nigay on 03.04.2023.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: Coin
    private let imageService: CoinImageService
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ coin: Coin) {
        self.coin = coin
        self.imageService = CoinImageService(coin)
        addSubscribers()
        isLoading = true
    }
    
    private func addSubscribers() {
        imageService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] receivedImage in
                self?.image = receivedImage
            }
            .store(in: &cancellable)
    }
}
