//
//  ContainerFactory.swift
//  DataLayer
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import Foundation
import Model
import SwiftData

public enum ContainerFactory {
    
    static public func build(isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let config: any DataStoreConfiguration = ModelConfiguration.init(isStoredInMemoryOnly: isStoredInMemoryOnly)
        return try ModelContainer(for: WordCard.self, configurations: config)
    }
}


