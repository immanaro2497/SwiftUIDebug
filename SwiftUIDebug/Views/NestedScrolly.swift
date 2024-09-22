//
//  NestedScrolly.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 21/09/24.
//

import SwiftUI

struct NestedScrolly: View {
    var body: some View {
        ScrollView {
            
            HStack{
                
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(0..<5) { item in
                            Text("Item \(item)")
                        }
                    } header: {
                        Text("Header One")
                        // give background here
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.gray)
                    }
                }
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(pinnedViews: [.sectionHeaders]) {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(0..<5) { item in
                                    HStack{
                                        ForEach(0..<9) { item in
                                            Text("Item \(item)")
                                        }
                                    }
                                }
                            } header: {
                                HStack(spacing: 0) {
                                    Text("a")
                                        .frame(width: 80)
                                    Text("b")
                                        .frame(width: 80)
                                    Text("d")
                                        .frame(width: 100)
                                    Text("i")
                                        .frame(width: 80)
                                    
                                    Text("e")
                                        .frame(width: 80)
                                    Text("f")
                                        .frame(width: 100)
                                    Text("g")
                                        .frame(width: 100)
                                    Text("h")
                                        .frame(width: 100)
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.1))
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        .font(.title2)
        .padding()
    }
}

#Preview {
    NestedScrolly()
}

struct Purchase: Identifiable {
    let price: Decimal
    let id = UUID()
}


struct TableTest: View {
    let currencyStyle = Decimal.FormatStyle.Currency(code: "USD")


    var body: some View {
        Table(of: Purchase.self) {
            TableColumn("Base price") { purchase in
                Text(purchase.price, format: currencyStyle)
            }
            TableColumn("With 15% tip") { purchase in
                Text(purchase.price * 1.15, format: currencyStyle)
            }
            TableColumn("With 20% tip") { purchase in
                Text(purchase.price * 1.2, format: currencyStyle)
            }
            TableColumn("With 25% tip") { purchase in
                Text(purchase.price * 1.25, format: currencyStyle)
            }
        } rows: {
            TableRow(Purchase(price: 20))
            TableRow(Purchase(price: 50))
            TableRow(Purchase(price: 75))
        }
    }
}
