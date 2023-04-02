//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Alik Nigay on 02.04.2023.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var cancelable = Set<AnyCancellable>()
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en") else { return }
        
        coinSubscription = NetworkingManager.download(url)
            .decode(type: [Coin].self, decoder: decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedCoins in
                self?.allCoins = receivedCoins
                self?.coinSubscription?.cancel()
            })

    }
}
