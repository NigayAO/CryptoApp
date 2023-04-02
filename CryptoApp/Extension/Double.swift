//
//  Double.swift
//  CryptoApp
//
//  Created by Alik Nigay on 02.04.2023.
//

import Foundation

extension Double {
    
    private var currencyFormatted2: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatted2.string(from: number) ?? "$0.00"
    }
    
    ///Converts a Double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234,56 to $1.234,56
    ///Convert 12,3456 to $12,3456
    ///Convert 0,123456 to $0,123456
    ///```
    
    private var currencyFormatted6: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatted6.string(from: number) ?? "$0.00"
    }
    
    func asNumberString() -> String {
        String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        asNumberString() + "%"
    }
}
