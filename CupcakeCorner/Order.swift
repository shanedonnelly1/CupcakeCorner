//
//  Order.swift
//  CupcakeCorner
//
//  Created by Shane on 12/10/2020.
//

import Foundation

class OrderContainer: ObservableObject {
    @Published var order = Order()
}

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        for stringField in [name, streetAddress, city, zip] {
            if stringField.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
        }
        
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
