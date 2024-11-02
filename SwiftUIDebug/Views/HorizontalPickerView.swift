//
//  HorizontalPickerView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 27/09/24.
//

import SwiftUI
import Combine

struct HorizontalPickerView: View {
    @State private var selectedInt = 110
    @State private var selectedString = "Apple"
    @State private var selectedFloat: Float = 5.5

    var body: some View {
        VStack(spacing: 30) {
            // Integer picker
            HorizontalPicker(selectedValue: $selectedInt, values: Array(80...200))
                .frame(height: 150)

            // String picker
            HorizontalPicker(selectedValue: $selectedString, values: ["Apple", "Banana", "Cherry", "Date", "Elderberry"])
                .frame(height: 150)
            
            // Float picker
            HorizontalPicker(selectedValue: $selectedFloat, values: stride(from: 1.0, through: 10.0, by: 0.5).map { Float($0) })
                .frame(height: 150)
        }
    }
}

struct HorizontalPicker<T: Hashable & CustomStringConvertible>: View {
    @Binding var selectedValue: T // Binding for the selected value
    let values: [T]               // The array of values to display
    let itemWidth: CGFloat = 80   // Width of each item
    
    let isScrolling = PassthroughSubject<Void, Never>()

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Picker label
            VStack {
                Text("Select Value")
                    .fontWeight(.semibold)

                ZStack {
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.green)

                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { scrollView in
                            HStack(spacing: 20) {
                                // Add padding to ensure centering for the first and last elements
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width / 2) - (itemWidth / 2))
                                
                                ForEach(values, id: \.self) { value in
                                    Text("\(value.description)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(selectedValue == value ? .white : .black)
                                        .background(
                                            Circle()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(selectedValue == value ? .blue : .clear)
                                        )
                                        .background(GeometryReader { geo in
                                            Color.clear
                                                .onChange(of: geo.frame(in: .global).midX) { midX in
                                                    // Calculate screen's center
                                                    let screenCenterX = UIScreen.main.bounds.width / 2
                                                    let distance = abs(midX - screenCenterX)
                                                    let tolerance: CGFloat = 20 // Adjust tolerance as needed
                                                    if distance < tolerance {
                                                        print("set selected on scroll")
                                                        selectedValue = value
                                                    }
                                                    print("sending", Date())
                                                    isScrolling.send()
                                                }
                                        })
                                        .onTapGesture {
                                            // Scroll to the tapped value and select it
                                            withAnimation {
                                                selectedValue = value
                                                print("tapped")
                                                scrollView.scrollTo(value, anchor: .center)
                                            }
                                        }
                                        .id(value) // Assign id for ScrollViewReader
                                }
                                
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width / 2) - (itemWidth / 2))
                            }
                            .onReceive(isScrolling.debounce(for: 0.2, scheduler: RunLoop.main), perform: { _ in
                                withAnimation {
                                    print("receive scrolling")
                                    let classInstanceAddress = MemoryAddress(of: isScrolling)
                                    print(String(format: "%018p", classInstanceAddress.intValue))
                                    let structInstanceAddress = MemoryAddress(of: &selectedValue)
                                    print(String(format: "%018p", structInstanceAddress.intValue))
                                    scrollView.scrollTo(selectedValue, anchor: .center)
                                }
                            })
                            .onAppear {
                                // Scroll to the initially selected value when the view appears
                                DispatchQueue.main.async {
                                    scrollView.scrollTo(selectedValue, anchor: .center)
                                }
                            }
                        }
                    }
                    .frame(height: 100) // Constrain the height of the ScrollView
                }
            }

            Spacer()
            
            // Show selected value
            VStack(alignment: .leading) {
                Text("Selected Value: \(selectedValue.description)")
            }
        }
        .padding()
    }
}

#Preview(body: {
    HorizontalPickerView()
})
