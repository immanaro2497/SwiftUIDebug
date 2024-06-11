//
//  ChartView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 04/06/24.
//

import SwiftUI
import Charts

struct ToyShape: Identifiable {
    var color: String
    var type: String
    var count: Double
    var id = UUID()
}

//var data: [ToyShape] = [
//    .init(type: "Cube", count: 5),
//    .init(type: "Sphere", count: 4),
//    .init(type: "Pyramid", count: 4)
//]

var stackedBarData: [ToyShape] = [
    .init(color: "Green", type: "Cube", count: 2),
    .init(color: "Green", type: "Sphere", count: 0),
    .init(color: "Green", type: "Pyramid", count: 1),
    .init(color: "Purple", type: "Cube", count: 1),
    .init(color: "Purple", type: "Sphere", count: 1),
    .init(color: "Purple", type: "Pyramid", count: 1),
    .init(color: "Pink", type: "Cube", count: 1),
    .init(color: "Pink", type: "Sphere", count: 2),
    .init(color: "Pink", type: "Pyramid", count: 0),
    .init(color: "Yellow", type: "Cube", count: 1),
    .init(color: "Yellow", type: "Sphere", count: 1),
    .init(color: "Yellow", type: "Pyramid", count: 2)
]

struct ProfitOverTime {
    var date: Date
    var profit: Double
}

let departmentAProfit: [ProfitOverTime] = [
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 1), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 2), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 3), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 4), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 5), profit: .random(in: 1...10))
]
let departmentBProfit: [ProfitOverTime] = [
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 1), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 2), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 3), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 4), profit: .random(in: 1...10)),
    ProfitOverTime(date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 5), profit: .random(in: 1...10))
]

struct ChartView: View {
    var body: some View {
        Chart {
//            ForEach(stackedBarData) { shape in
//                BarMark(
//                    x: .value("Total Count", shape.count)
//                )
//                .foregroundStyle(by: .value("Shape Type", shape.type))
//            }
            ForEach(departmentAProfit, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Profit A", item.profit),
                    series: .value("Company", "A")
                )
                .foregroundStyle(.blue)
            }
            .interpolationMethod(.stepCenter)
            .symbol(.circle)
            ForEach(departmentBProfit, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Profit B", item.profit),
                    series: .value("Company", "B")
                )
                .foregroundStyle(.green)
            }
            RuleMark(
                y: .value("Threshold", 5)
            )
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    ChartView()
}
