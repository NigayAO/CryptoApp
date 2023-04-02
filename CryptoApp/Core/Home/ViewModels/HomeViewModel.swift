//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Alik Nigay on 02.04.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    private let dataService = CoinDataService()
    
    private var cancellabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] receivedCoins in
                self?.allCoins = receivedCoins
            }
            .store(in: &cancellabels)
    }
}
