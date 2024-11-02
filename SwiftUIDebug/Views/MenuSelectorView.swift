//
//  MenuSelectorView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 10/10/24.
//

import SwiftUI

// TODO: ListView rerenders continuously if it has @Binding or @Environment(\.dismiss) used in closure. this does not happen when ListDetail is Equatable
struct MenuSelectorView: View {
    var body: some View {
            VStack(spacing: 20) {
                // First Menu Option
                NavigationLink(destination: MainView()) {
                    Text("First Menu")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Second Menu Option
                NavigationLink(destination: MainView()) {
                    Text("Second Menu")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Third Menu Option
                NavigationLink(destination: MainView()) {
                    Text("Third Menu")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Menu Selector")
        }
}

class ItemViewModel: ObservableObject {
    // Sample data
    @Published var items: [ItemOne] = [
        ItemOne(id: 1, name: "Item 1", description: "Description for item 1"),
//        ItemOne(id: 2, name: "Item 2", description: "Description for item 2"),
//        ItemOne(id: 3, name: "Item 3", description: "Description for item 3")
    ] {
        willSet {
            print("items will change")
        }
    }
    
    // For navigation to the detail view
    @Published var selectedItem: Item?
}


struct ItemOne: Identifiable {
    let id: Int
    let name: String
    let description: String
}


extension ItemOne {
    // Mock data for preview
     static let mockList: [ItemOne] = [
        ItemOne(id: 1, name: "Mock Item 1", description: "Mock description for item 1"),
        ItemOne(id: 2, name: "Mock Item 2", description: "Mock description for item 2"),
        ItemOne(id: 3, name: "Mock Item 3", description: "Mock description for item 3"),
        ItemOne(id: 4, name: "Mock Item 4", description: "Mock description for item 4")
    ]
}

struct MainView: View {
    @StateObject private var viewModel = ItemViewModel()
    
    var body: some View {
        let _ = Self._printChanges()
            ListView(items: $viewModel.items)
                .navigationTitle("Items")
    }
}

struct ListView: View {
    
    @Binding var items: [ItemOne]
    @Environment(\.dismiss) private var dismiss
    
//    init(items: Binding<[ItemOne]>) {
//        _items = items
//    }
    
    var body: some View {
        let _ = Self._printChanges()
        List(items) { item in
            ListRowItem(item: item) { isSuccess in
                if isSuccess {
                    dismiss()
                }
            }
        }
    }
}

struct ListRowItem: View {
    let item: ItemOne
    var onSuccess: (Bool) -> Void
    
    var body: some View {
        NavigationLink(
            destination: ListDetail(item: item, onSuccess: onSuccess),
            label: {
                ListRow(item: item)
            }
        )
    }
}

struct ListDetail: View {
    
//    struct ListDetail: View, Equatable {
//    static func == (lhs: ListDetail, rhs: ListDetail) -> Bool {
//        lhs.item.id == rhs.item.id
//    }
    
    let item: ItemOne
    var onSuccess: (Bool) -> Void
    
    // Access to dismiss the current view
//    @Environment(\.dismiss) private var dismiss
    
//    init(item: ItemOne, onSuccess: @escaping (Bool) -> Void) {
//        print(ListDetail.self, #function)
//        print(_isPOD(ListDetail.self))
//        self.item = item
//        self.onSuccess = onSuccess
//        print("Initialized with item: \(item)")
//    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack(alignment: .leading, spacing: 16) {
            Text(item.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(item.description)
                .font(.body)
            
            Spacer()
            
            // Button to trigger the asynchronous task
            Button(action: {
                onSuccess(true)
            }) {
                Text("Perform Action")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .navigationTitle("Detail")
    }
}

struct ListRow: View {
    let item: ItemOne
    
    var body: some View {
        let _ = Self._printChanges()
        HStack {
            Text(item.name)
                .font(.headline)
            Spacer()
        }
        .padding()
    }
}
