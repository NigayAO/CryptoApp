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
    private let fileManager = LocaleFileManager.shared
    private let folderName = "coin_images"
    private let imageName: String
    
    init(_ coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName, folderName) {
            image = savedImage
            print("Retrieved image from File Manager")
        } else {
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url)
            .tryMap { (data) -> UIImage? in UIImage(data: data) }
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedImage in
                guard let self = self, let downloadedImage = receivedImage else { return }
                self.image = receivedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(downloadedImage, self.imageName, self.folderName)
            })
    }
}
