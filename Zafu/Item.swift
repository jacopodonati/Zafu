//
//  Item.swift
//  Zafu
//
//  Created by Jacopo Donati on 17/02/24.
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
