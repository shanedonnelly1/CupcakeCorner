//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Shane on 12/10/2020.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var orderContainer: OrderContainer
    @State private var confirmationMessage = ""
    @State private var titleMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.orderContainer.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(titleMessage), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(orderContainer.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.titleMessage = "Something went wrong"
                self.confirmationMessage = "\(error?.localizedDescription ?? "Unknown error.")"
                self.showingAlert = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.titleMessage = "Thank you!"
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingAlert = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderContainer: OrderContainer())
    }
}
