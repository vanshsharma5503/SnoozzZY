//
//  ExerciseTimerVIew.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 14/09/24.
//
import SwiftUI
import Combine

struct ExerciseTimerView: View {
    @Binding var exerciseName: String
    var onSave: (Int) -> Void
    
    @State private var counter: Int = 0
    @State private var countTo: Int = 0
    @State private var isRunning: Bool = false
    @State private var showingPicker: Bool = false
    
    @Environment(\.presentationMode) var presentationMode // Add this line
    
    var body: some View {
        VStack {
            ZStack {
                Background()
                CountdownView(title: exerciseName, counter: $counter, countTo: $countTo, isRunning: $isRunning, onSave: { duration in
                    // Pass the duration back and dismiss the sheet
                    onSave(duration)
                    presentationMode.wrappedValue.dismiss()
                })
            }
            .onDisappear {
                // Pass the duration back when the view disappears
                onSave(countTo - counter)
            }
        }
    }
}


struct ExerciseTimerView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseTimerView(exerciseName: .constant("Sample Exercise")) { duration in
            // Handle the duration update here if needed
            print("Duration saved: \(duration)")
        }
    }
}

import SwiftUI

// Timer setup
let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct Clock: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.custom("Avenir Next", size: 60))
                .fontWeight(.black)
                .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255))
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = counter
        let seconds = currentTime % 60
        let minutes = (currentTime / 60) % 60
        let hours = (currentTime / 3600)
        
        return "\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

struct ProgressTrack: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 350, height: 350)
            .overlay(
                Circle().stroke(Color(.white).opacity(0.7), lineWidth: 15)
            )
    }
}

struct ProgressBar: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 350, height: 350)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress())
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(
                        Color(red: 199/255, green: 125/255, blue: 255/255)
                    )
                    .animation(
                        .easeInOut(duration: 0.2)
                    )
                    .rotationEffect(.degrees(-90)) // Rotate the circle to start from the top
            )
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(countTo)
    }
}


struct CountdownView: View {
    var title: String
    @Binding var counter: Int
    @Binding var countTo: Int
    @Binding var isRunning: Bool
    var onSave: (Int) -> Void
    
    @State private var showingPicker: Bool = false
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellable: Cancellable? = nil
    
    var body: some View {
        VStack {
            HStack(spacing: 60) {
                Text(title)
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255))
                    .fontWeight(.bold)
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .offset(x: -20)
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 224/255, green: 170/255, blue: 255/255))
                    .frame(width: 130, height: 50)
                    .overlay(
                        Text("Save")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    )
                    .offset(x: -1)
                    .onTapGesture {
                        // Save the current counter value and dismiss the sheet
                        onSave(countTo - counter)
                    }
            }
            .padding(.top, 30)
            
            ZStack {
                ProgressTrack()
                ProgressBar(counter: counter, countTo: countTo)
                
                if showingPicker {
                    VStack(spacing: 20) {
                        HStack {
                            Picker("Hours", selection: $selectedHours) {
                                ForEach(0..<24, id: \.self) {
                                    Text("\($0) h")
                                        .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255))
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80)
                            
                            Picker("Minutes", selection: $selectedMinutes) {
                                ForEach(0..<60, id: \.self) {
                                    Text("\($0) m")
                                        .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255))
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80)
                            
                            Picker("Seconds", selection: $selectedSeconds) {
                                ForEach(0..<60, id: \.self) {
                                    Text("\($0) s")
                                        .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255))
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80)
                        }
                        Button("Set Time") {
                            let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
                            countTo = totalSeconds
                            counter = totalSeconds // Start from total time
                            isRunning = false
                            showingPicker = false // Hide picker after setting time
                        }
                        .padding()
                        .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                    }
                    .padding()
                } else {
                    VStack {
                        Clock(counter: counter, countTo: countTo)
                        Button("Change") {
                            showingPicker.toggle()
                        }
                        .padding()
                        .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            if title.lowercased() == "yoga" {
                Image("Yoga")
                    .resizable()
                    .scaledToFit()
            } else if title.lowercased() == "meditation" {
                Image("meditation")
                    .resizable()
                    .scaledToFit()
            }
            
            HStack(spacing: 20) {
                Button(action: startTimer) {
                    Text("Start")
                        .padding()
                        .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                }
                
                Button(action: stopTimer) {
                    Text("Stop")
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 224/255, green: 170/255, blue: 255/255), lineWidth: 5)
                        )
                }

                Button(action: resumeTimer) {
                    Text("Resume")
                        .padding()
                        .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                }
            }
        }
        .onReceive(timer) { _ in
            if isRunning && counter > 0 {
                counter -= 1
            }
        }
    }
    
    func startTimer() {
        if counter > 0 {
            isRunning = true
            // Reinitialize timer and start it
            timer = Timer.publish(every: 1, on: .main, in: .common)
            if cancellable == nil {
                cancellable = timer.connect()
            }
        }
    }
    
    func stopTimer() {
        isRunning = false
        cancellable?.cancel()
        cancellable = nil
    }
    
    func resumeTimer() {
        if !isRunning && counter > 0 {
            isRunning = true
            // Reinitialize timer and start it
            timer = Timer.publish(every: 1, on: .main, in: .common)
            if cancellable == nil {
                cancellable = timer.connect()
            }
        }
    }
}
