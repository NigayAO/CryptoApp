//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Alik Nigay on 03.04.2023.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    
    init(_ coin: Coin) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url)
            .tryMap { data -> UIImage? in UIImage(data: data) }
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedImage in
                self?.image = receivedImage
                self?.imageSubscription?.cancel()
            })
    }
}
