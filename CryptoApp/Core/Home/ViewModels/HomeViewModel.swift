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
    
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancelabels = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func updatePortfolio(_ coin: Coin, _ amount: Double) {
        portfolioDataService.updatePortfolio(coin, amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(.success)
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
                
        //updates portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancelabels)
        
        //Update market data here
        marketDataService.$globalData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
//            .assign(to: \.statistics, on: self)
            .sink(receiveValue: { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            })
            .store(in: &cancelabels)
    }
    
    private func mapAllCoinsToPortfolioCoins(_ allCoins: [Coin], _ portfolioEntities: [PortfolioEntity]) -> [Coin] {
        allCoins.compactMap { coinModel in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coinModel.id }) else {
                return nil
            }
            return coinModel.updateHoldings(entity.amount)
        }
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
    
    private func mapGlobalMarketData(_ marketDataModel: MarketDataModel?, _ portfolioCoins: [Coin]) -> [Statistic] {
        var stats = [Statistic]()
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingValue }.reduce(0, +)
        
        let previousValue =
        portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingValue
                let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}

/*
             .map { (text, startingCoins) -> [Coin] in
                 guard !text.isEmpty else {
                     return startingCoins
                 }
 
                 let lowerText = text.lowercased()
 
                 return startingCoins.filter { coin -> Bool in
                     return coin.name.contains(lowerText) || coin.symbol.contains(lowerText) || coin.id.contains(lowerText)
                 }
             }
 
             .map { marketDataModel -> [Statistic] in
                 var stats = [Statistic]()
 
                 guard let data = marketDataModel else { return stats }
 
                 let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                 let volume = Statistic(title: "24h Volume", value: data.volume)
                 let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                 let portfolio = Statistic(title: "Portfolio Value", value: "0.00", percentageChange: 0)
 
                 stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
                 return stats
             }
 .map { (coins, portfolioEntities) -> [Coin] in
     coins.compactMap {coinModel in
         guard let entity = portfolioEntities.first(where: { $0.coinID == coinModel.id }) else {
             return nil
         }
         return coinModel.updateHoldings(entity.amount)
     }
 }
 */
