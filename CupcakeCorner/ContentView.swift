//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Shane on 12/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orderContainer = OrderContainer()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderContainer.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $orderContainer.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(orderContainer.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $orderContainer.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if orderContainer.order.specialRequestEnabled {
                        Toggle(isOn: $orderContainer.order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $orderContainer.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(
                        destination: AddressView(orderContainer: orderContainer)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
