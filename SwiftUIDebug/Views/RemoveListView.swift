//
//  RemoveListView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 04/10/24.
//

import SwiftUI

struct ValueItem: Identifiable {
    var id: UUID = UUID()
    let value: String
}

// TODO: update rowList correctly when removed from list. Issue is RowViewModel deinit not called
struct RemoveListView: View {

    @State private var rowList: [RowViewModel]
    
    init() {
        let list: [ValueItem] = [
            ValueItem(value: "A"), ValueItem(value: "B"), ValueItem(value: "C")
        ]
        _rowList = State(initialValue: list.map { RowViewModel(item: $0.value) })
    }

    var body: some View {
        List {
            ForEach(rowList, id: \.id) { item in
                @Bindable var vm: RowViewModel = item
                RowView(vm: vm)
                TextField("type", text: $vm.item)
//                    .onAppear {
//                        print("RowView Appear")
//                    }
//                    .onDisappear {
//                        print("RowView Disappear")
//                    }
            }
            .onDelete(perform: { indexSet in
                print("IndexSet: \(indexSet.map { $0 })")
                indexSet.forEach { rowList.remove(at: $0) }
            })
        }
    }
}

struct RowView: View {
    var vm: RowViewModel

//    init(item: ValueItem) {
//        vm = RowViewModel(item: item.value)
//        _vm = StateObject(wrappedValue: .init(item: item.value))
//        vm = RowViewModel(item: item)
//    }

    var body: some View {
        Text(vm.item)
    }
}

@Observable
class RowViewModel: Identifiable {
    public let id: UUID = UUID()
    public var item: String

    init(item: String) {
        print("RowVM:Init \(item)")
        self.item = item
    }

    deinit {
        print("RowVM:Deinit \(item)")
    }
}

#Preview {
    RemoveListView()
}
