//
//  LocaleFileManager.swift
//  CryptoApp
//
//  Created by Alik Nigay on 03.04.2023.
//

import SwiftUI

class LocaleFileManager {
    static let shared = LocaleFileManager()
    
    private init() {}
    
    func saveImage(_ image: UIImage, _ imageName: String, _ folderName: String) {
        
        createFolderIfNeeded(folderName)
        
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName, folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image: \(error.localizedDescription). Image name - \(imageName)")
        }
    }
    
    func getImage(_ imageName: String, _ folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName, folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path )
    }
    
    private func createFolderIfNeeded(_ folderName: String) {
        guard let url = getURLFolder(folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory: Folder name - \(folderName).\(error.localizedDescription)")
            }
        }
    }
    
    private func getURLFolder(_ folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(_ imageName: String, _ folderName: String) -> URL? {
        
        guard let folderURL = getURLFolder(folderName) else { return nil }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
