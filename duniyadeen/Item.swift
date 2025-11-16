//
//  Item.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
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
