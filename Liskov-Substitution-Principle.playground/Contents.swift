//: Playground - noun: a place where people can play

import Foundation


protocol Item {
    var name: String { get }
    var price: Float { get }
    var restrictions: [Restriction] { get }
}

extension Item {
    var restrictions: [Restriction] {
        return []
    }
}

protocol Taxable {
}

protocol Restriction {
    func ableToPurchase(by customer: Customer) -> Bool
}

struct Food : Item {
    let name: String
    let price: Float
}

struct Good : Item, Taxable {
    let name: String
    let price: Float
}

struct AgeRestriction : Restriction {
    let minimumAge: Int
}

extension AgeRestriction {
    func ableToPurchase(by customer: Customer) -> Bool {
        return customer.age >= minimumAge
    }
}

struct Beer : Item {
    let name = "Beer"
    let price: Float = 4.95
    
    var restrictions: [Restriction] {
        return [AgeRestriction(minimumAge: 21)]
    }
}

func formatDollars(_ x: Float) -> String {
    return String(format: "%.2f", x)
}

func checkout(items: [Item], taxRate: Float, customer: Customer) {
    var total: Float = 0
    var subtotal: Float = 0
    var taxableTotal: Float = 0
    for item in items {
        
        let failedRestriction = item.restrictions.first { !$0.ableToPurchase(by: customer) }
        if let r = failedRestriction {
            print("Customer is unable to purchase \(item.name). Failed restriction: \(r)")
            continue
        }
        
        print("\(item.name)    \(formatDollars(item.price))")
        subtotal += item.price
        
        if item is Taxable {
            taxableTotal += item.price
        }
    }
    
    let tax = taxableTotal * taxRate
    total = subtotal + tax
    print("------------------------")
    print("SUBTOTAL:     \(formatDollars(subtotal))")
    print("TAX:     \(formatDollars(tax))")
    print("TOTAL:     \(formatDollars(total))")
}

struct Customer {
    let age: Int
}

var items: [Item] = [
    Food(name: "Bananas", price: 1.25),
    Food(name: "Cereal", price: 3.75),
    Good(name: "Candy", price: 2.50),
    Beer()
]

let customer = Customer(age: 19)
checkout(items: items, taxRate: 0.0825, customer: customer)
