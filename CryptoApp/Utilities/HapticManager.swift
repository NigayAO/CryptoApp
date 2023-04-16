//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Alik Nigay on 17.04.2023.
//

import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
