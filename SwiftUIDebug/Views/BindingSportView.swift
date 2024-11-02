//
//  BindingSportView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 03/10/24.
//

import SwiftUI

struct SportProgramModel: Codable, Identifiable {
    var id = UUID().uuidString
    let title: String
    let description: String
    let author: String
    let shared: Bool
    let trainingDays: [TrainingDayListValues]
}

struct TrainingDayListValues: Codable, Identifiable{
    var id = UUID().uuidString
    var trainingDayType: trainingDaysTypes
}

enum trainingDaysTypes: Codable{
    case workout(TrainingDayModel)
    case rest(String)
    
//    var workout: TrainingDayModel? {
//        get {
//            switch self {
//            case .workout(let trainingDayModel):
//                trainingDayModel
//            case .rest(let string):
//                nil
//            }
//        }
//        set {
//            if let newValue {
//                self = .workout(newValue)
//            }
//        }
//    }
}

struct TrainingDayModel: Codable, Identifiable {
    var id = UUID().uuidString
    var title: String
    let setOfExercises: [SetOfExercisesModel]
}

struct SetOfExercisesModel: Codable, Identifiable {
    var id = UUID().uuidString
    let title: String
}


class SportProgramViewModel: ObservableObject {
    
    @Published var sportProgram: SportProgramModel?
    @Published var trainingDaysList: [TrainingDayListValues] = [] {
        willSet {
            print(trainingDaysList.first)
        }
    }
    
    func getSportProgramDetails(sportProgramID: String) async {
        do {
            self.trainingDaysList = [
                TrainingDayListValues(trainingDayType:
                        .workout(
                            TrainingDayModel(title: "Hand", setOfExercises: [
                                SetOfExercisesModel(title: "Bicep curl"),
                                SetOfExercisesModel(title: "Tricep extension")
                            ])
                        )
                ),
                TrainingDayListValues(trainingDayType:
                        .workout(
                            TrainingDayModel(title: "Ab", setOfExercises: [
                                SetOfExercisesModel(title: "Leg raise"),
                                SetOfExercisesModel(title: "Situps")
                            ])
                        )
                ),
                TrainingDayListValues(trainingDayType:
                        .rest("two")
                )
            ]
        } catch {
            print("Error when getting sport program")
        }
    }
    
    init() {
        let classInstanceAddress = MemoryAddress(of: self)
        let address = String(format: "%018p", classInstanceAddress.intValue)
        print("Sport program init address: \(address)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        let address = String(format: "%018p", classInstanceAddress.intValue)
        print("Sport program deinit address: \(address)")
    }
}

struct SportProgramView: View {
    @ObservedObject var sportProgramViewModel = SportProgramViewModel()
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var author = ""
    @State private var shared: Bool = false

    @State private var restDays = ""
    @State private var showRestDayView: Bool = false
    @State private var didLoad: Bool = false

    var sportPorgramID: String?
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            VStack {
                TextField("Name your program", text: $title)
                Divider()
                TextField("Enter descripton", text: $description)
                Text("author id" + author)
            }
            
            TrainingDaysListView(trainingDaysList: $sportProgramViewModel.trainingDaysList)
            
//            List {
//                ForEach($sportProgramViewModel.trainingDaysList){ $day in
//                    switch day.trainingDayType {
//                    case .workout(let workout):
//                        NavigationLink {
//                            TrainingDayView(trainingDay: $day.trainingDayType.workout)
//                        } label: {
//                            Text(workout.title)
//                        }
//                    case .rest(let rest):
//                        Text("Rest for " + rest + " days")
//
//                    }
//                }
//            }
            
        }
        .onAppear {
            if !didLoad {
                print("On appear")
    //            if let id = sportPorgramID {
                    Task{
                        await sportProgramViewModel.getSportProgramDetails(sportProgramID: "random id")
                        //update data
                        title = sportProgramViewModel.sportProgram?.title ?? ""
                        description = sportProgramViewModel.sportProgram?.description ?? ""
                        author = sportProgramViewModel.sportProgram?.author ?? ""
                        shared = sportProgramViewModel.sportProgram?.shared ?? false
                    }
    //            }
                didLoad = true
            }
        }
        .navigationTitle("New program")
    }

}

struct TrainingDaysListView: View {
    
    @Binding var trainingDaysList: [TrainingDayListValues]
    
    var body: some View {
        List {
            ForEach($trainingDaysList) { $day in
                TrainingDayTypeView(trainingDayType: $day.trainingDayType)
            }
        }
    }
}

struct TrainingDayTypeView: View {
    
    @Binding var trainingDayType: trainingDaysTypes
    
    var body: some View {
        switch trainingDayType {
        case .workout(let workout):
            NavigationLink {
                TrainingDayView(
                    trainingDay:
                        Binding(get: {
                            workout
                        }, set: { newValue in
                            trainingDayType = .workout(newValue)
                        })
                )
            } label: {
                Text(workout.title)
            }
        case .rest(let rest):
            Text("Rest for " + rest + " days")
        }
    }
}

struct TrainingDayView: View {
    
    @Binding var trainingDay: TrainingDayModel
    
    var body: some View {
        NavigationStack{
            VStack{
                TextField("Name yor day", text: $trainingDay.title)
            }
            .padding()
        }
    }
}
