//
//  PersistentWordCardRepository.swift
//  DataLayer
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import Foundation
import Model
import SwiftData

public protocol PersistentWordCardRepositoryProtocol {
    func insert(_ model: WordCard) throws
    func delete(_ id: UUID) throws
    func update(_ id: UUID, status: ResultStatus) throws
    func retrieve(_ id: UUID) throws -> WordCard?
    func retreiveAll(order: SortOrder) throws -> [WordCard]
    func purge() throws
}

public final class PersistentWordCardRepository: PersistentWordCardRepositoryProtocol {
      
    private let context: ModelContext
    
    public init(container: ModelContainer) {
        self.context = .init(container)
    }
    
    public func insert(_ model: Model.WordCard) throws {
        context.insert(model)
        try context.save()
    }
    
    public func delete(_ id: UUID) throws {
        let model =  try context.fetch(
            FetchDescriptor<WordCard>(predicate: #Predicate {
                $0.id == id
            })
        ).first
        
        if let model {
            context.delete(model)
            try context.save()
        }
    }
    
    public func update(_ id: UUID, status: Model.ResultStatus) throws {
        let model =  try context.fetch(
            FetchDescriptor<WordCard>(predicate: #Predicate {
                $0.id == id
            })
        ).first
        
        if let model {
            model.status = status
            try context.save()
        }
    }
    
    public func retreiveAll(order: SortOrder) throws -> [Model.WordCard] {
        try context.fetch(
            FetchDescriptor<WordCard>(sortBy: [SortDescriptor(\.createdAt, order: order)])
        )
    }
    
    public func retrieve(_ id: UUID) throws -> Model.WordCard? {
        try context.fetch(
            FetchDescriptor<WordCard>(predicate: #Predicate {
                $0.id == id
            })
        ).first
    }
    
    public func purge() throws {
        try context.container.erase()
    }
}

