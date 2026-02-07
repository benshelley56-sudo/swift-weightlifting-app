

import SwiftUI


struct ContentView: View {
    var body: some View {
        
        NavigationStack {
             
            VStack {
//                image
                Image("manwithdumbbell")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 450)
//                Title
                Text("Daily Exercise Tracker")
                    .font(.title)
//                second page button
                NavigationLink {
                    SecondView()
                } label: {
                    Text("Track Your Exercise")
                        .font(.headline)
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SecondView: View {
    let bodyWeight = ["Pushups", "Sit-ups", "Squats", "Crunches", "Plank", "Pull-ups", "Dips", "Lunges"]
    let cardio = ["Running", "Cycling", "Jump Rope", "Burpees", "Stair Climbing", "Box Jumps", "Mountain Climbers", "High Knees"]
    let weights = ["Bench Press", "Incline Dumbbell Bench Press", "Lateral Raises", "Bicep Curls", "Skull Crushers", "Deadlift", "Squat", "Leg Press", "Hack Squat", "Leg Extensions", "Leg Curls", "Shoulder Press", "Rows"]
    
    @State private var selectedType = "Body Weight"
    let exerciseType = ["Body Weight", "Cardio", "Weights"]
    
    @AppStorage("selectedExercises") private var selectedExercisesData: String = ""
    @State private var selectedExercises: Set<String> = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Exercise Selection")
                .font(.largeTitle)
                .padding(.top)
            
            Picker("type", selection: $selectedType) {
                ForEach(exerciseType, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Text("Tap exercises to select")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            List(currentExercises, id: \.self) { exercise in
                HStack {
                    Text(exercise)
                    Spacer()
                    if selectedExercises.contains(exercise) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSelection(for: exercise)
                }
            }
            
            if !selectedExercises.isEmpty {
                VStack(spacing: 10) {
                    Text("\(selectedExercises.count) exercise(s) selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    NavigationLink {
                        ThirdView()
                    } label: {
                        Text("View My Exercises")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            loadSelectedExercises()
        }
    }
    
    var currentExercises: [String] {
        switch selectedType {
        case "Body Weight":
            return bodyWeight
        case "Cardio":
            return cardio
        case "Weights":
            return weights
        default:
            return []
        }
    }
    
    func toggleSelection(for exercise: String) {
        if selectedExercises.contains(exercise) {
            selectedExercises.remove(exercise)
        } else {
            selectedExercises.insert(exercise)
        }
        saveSelectedExercises()
    }
    
    func saveSelectedExercises() {
        let exercisesArray = Array(selectedExercises)
        if let encoded = try? JSONEncoder().encode(exercisesArray) {
            selectedExercisesData = String(data: encoded, encoding: .utf8) ?? ""
        }
    }
    
    func loadSelectedExercises() {
        guard !selectedExercisesData.isEmpty,
              let data = selectedExercisesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return
        }
        selectedExercises = Set(decoded)
    }
}

struct ThirdView: View {
    @AppStorage("selectedExercises") private var selectedExercisesData: String = ""
    @State private var selectedExercises: [String] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Exercise Plan")
                .font(.largeTitle)
                .padding(.top)
            
            if selectedExercises.isEmpty {
                Spacer()
                Text("No exercises selected")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(selectedExercises.sorted(), id: \.self) { exercise in
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(.blue)
                            Text(exercise)
                                .font(.body)
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Text("Total: \(selectedExercises.count) exercises")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("Select More Exercises")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            loadSelectedExercises()
        }
    }
    
    func loadSelectedExercises() {
        guard !selectedExercisesData.isEmpty,
              let data = selectedExercisesData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return
        }
        selectedExercises = decoded
    }
}

#Preview {
    ContentView()
}
