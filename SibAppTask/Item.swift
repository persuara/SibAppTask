//
//  Item.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
