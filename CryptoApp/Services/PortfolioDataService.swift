//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Alik Nigay on 16.04.2023.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    //MARK: - Public
    func updatePortfolio(_ coin: Coin, _ amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity, amount)
            } else {
                delete(entity)
            }
        } else {
            add(coin, amount)
        }
    }

    //MARK: - Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entity: \(error.localizedDescription)")
        }
    }
    
    private func add(_ coin: Coin, _ amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
//        savedEntities.append(entity)
//        save()
        
        applyChanges()
    }
    
    private func update(_ entity: PortfolioEntity, _ amount: Double) {
        entity.amount = amount
        
        applyChanges()
    }
    
    private func delete(_ entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
