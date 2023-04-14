//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Alik Nigay on 15.04.2023.
//

import SwiftUI
import Combine

class MarketDataService {
    @Published var globalData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    private let urlString = "https://api.coingecko.com/api/v3/global"
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init() {
        getMarketData()
    }
    
    private func getMarketData() {
        guard let url = URL(string: urlString) else { return }
        
        marketDataSubscription = NetworkingManager.download(url)
            .decode(type: GlobalData.self, decoder: decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.globalData = receivedData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
