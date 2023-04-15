//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Alik Nigay on 02.04.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancelabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        //Updates allcoins here
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelabels)
        
        marketDataService.$globalData
            .map(mapGlobalMarketData)
//            .map { marketDataModel -> [Statistic] in
//                var stats = [Statistic]()
//                
//                guard let data = marketDataModel else { return stats }
//                
//                let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
//                let volume = Statistic(title: "24h Volume", value: data.volume)
//                let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
//                let portfolio = Statistic(title: "Portfolio Value", value: "0.00", percentageChange: 0)
//                
//                stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
//                return stats
//            }
            .assign(to: \.statistics, on: self)
            .store(in: &cancelabels)
        
        //updates portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coin, portfolioEntities) -> [Coin] in
                coin.compactMap {coinModel in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coinModel.id }) else {
                        return nil
                    }
                    return coinModel.updateHoldings(entity.amount)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancelabels)
    }
    
    func updatePortfolio(_ coin: Coin, _ amount: Double) {
        portfolioDataService.updatePortfolio(coin, amount)
    }
    
    private func filterCoins(_ text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowerText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.contains(lowerText)
            || coin.symbol.contains(lowerText)
            || coin.id.contains(lowerText)
        }
    }
    
    private func mapGlobalMarketData(_ marketDataModel: MarketDataModel?) -> [Statistic] {
        var stats = [Statistic]()
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistic(title: "Portfolio Value", value: "0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}

/*
 //            .map { (text, startingCoins) -> [Coin] in
 //                guard !text.isEmpty else {
 //                    return startingCoins
 //                }
 //
 //                let lowerText = text.lowercased()
 //
 //                return startingCoins.filter { coin -> Bool in
 //                    return coin.name.contains(lowerText) || coin.symbol.contains(lowerText) || coin.id.contains(lowerText)
 //                }
 //            }
 */
