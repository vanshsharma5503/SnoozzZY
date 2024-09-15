//
//  ExerciseView.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 14/09/24.
//
import SwiftUI

struct ExerciseView: View {
    @State private var exercises: [Exercise] = []

    var body: some View {
        VStack {
            ZStack {
                Background()
                VStack {
                    HStack(spacing: 210) {
                        Text("Exercise")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .onTapGesture {
                                addNewExercise()
                            }
                    }.padding()
                    Spacer()
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach($exercises) { $exercise in
                                ExerciseRow(exercise: $exercise)
                            }
                            .onDelete(perform: deleteExercise)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    func addNewExercise() {
        exercises.append(Exercise(name: "", duration: 0))
    }
    
    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}

struct ExerciseRow: View {
    @Binding var exercise: Exercise
    @State private var showTimerView = false
    @State private var showRating = false
    @State private var rating: Int = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 350, height: 100)
            VStack {
                HStack {
                    if exercise.name.lowercased() == "yoga" {
                        Image("Yoga")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                    } else if exercise.name.lowercased() == "meditation" {
                        Image("meditation")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                    }
                    TextField("Enter exercise", text: $exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Image(systemName: "chevron.right")
                        .onTapGesture {
                            showTimerView.toggle()
                        }
                }
                Spacer()
                HStack {
                    if exercise.duration > 0 {
                        Text("Duration: \(exercise.duration) sec")
                            .padding(.trailing, 10)
                    }
                    RatingView(rating: $rating)
                   
                }
            }
            .padding()
            .sheet(isPresented: $showTimerView) {
                ExerciseTimerView(exerciseName: $exercise.name) { duration in
                    exercise.duration = duration
                    showRating.toggle()
                }
            }
        }
    }
}

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { num in
                Image(systemName: num <= rating ? "star.fill" : "star")
                    .foregroundColor(num <= rating ? .yellow : .gray)
                    .onTapGesture {
                        rating = num
                    }
            }
        }
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var duration: Int
}

#Preview {
    ExerciseView()
}
