//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Alik Nigay on 02.04.2023.
//

import Foundation
//MARK: - CoinGecko API

/*
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en
 
 JSON Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 28392,
     "market_cap": 548612536956,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 595871749669,
     "total_volume": 11150681290,
     "high_24h": 28741,
     "low_24h": 28338,
     "price_change_24h": -4.841886971604254,
     "price_change_percentage_24h": -0.01705,
     "market_cap_change_24h": -584682225.6210327,
     "market_cap_change_percentage_24h": -0.10646,
     "circulating_supply": 19334468,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -58.87564,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 41773.82592,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2023-04-01T18:53:28.531Z",
     "sparkline_in_7d": {
       "price": [
         27682.849497911746,
         27671.393084829055,
         27472.775494071037,
         27578.59447932372
       ]
     },
     "price_change_percentage_24h_in_currency": -0.017050740452198957
   }
 */

//class Coin {
//    let id: String
//    let symbol: String
//}

struct Coin: Identifiable, Decodable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    var currentHoldingValue: Double {
        (currentHoldings ?? 0.0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
    
    func updateHoldings(_ amount: Double) -> Coin {
        Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Decodable {
    let price: [Double]?
}
