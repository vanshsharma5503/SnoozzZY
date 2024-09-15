//
//  Timer.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 14/09/24.
//

//import SwiftUI
//
//// Timer setup
//let timer = Timer
//    .publish(every: 1, on: .main, in: .common)
//    .autoconnect()
//
//struct Clock: View {
//    var counter: Int
//    var countTo: Int
//    
//    var body: some View {
//        VStack {
//            Text(counterToMinutes())
//                .font(.custom("Avenir Next", size: 60))
//                .fontWeight(.black)
//                .foregroundColor(Color("2"))
//        }
//    }
//    
//    func counterToMinutes() -> String {
//        let currentTime = countTo - counter
//        let seconds = currentTime % 60
//        let minutes = (currentTime / 60) % 60
//        let hours = (currentTime / 3600)
//        
//        return "\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
//    }
//}
//
//struct ProgressTrack: View {
//    var body: some View {
//        Circle()
//            .fill(Color.clear)
//            .frame(width: 350, height: 350)
//            .overlay(
//                Circle().stroke(Color(.white).opacity(0.7), lineWidth: 15)
//            )
//    }
//}
//
//struct ProgressBar: View {
//    var counter: Int
//    var countTo: Int
//    
//    var body: some View {
//        Circle()
//            .fill(Color.clear)
//            .frame(width: 350, height: 350)
//            .overlay(
//                Circle().trim(from: 0, to: progress())
//                    .stroke(
//                        style: StrokeStyle(
//                            lineWidth: 15,
//                            lineCap: .round,
//                            lineJoin: .round
//                        )
//                    )
//                    .foregroundColor(
//                        Color(red:199/255,green: 125/255,blue: 255/255)
//                    )
//                    .animation(
//                        .easeInOut(duration: 0.2)
//                    )
//            )
//    }
//    
//    func completed() -> Bool {
//        return progress() == 1
//    }
//    
//    func progress() -> CGFloat {
//        return CGFloat(counter) / CGFloat(countTo)
//    }
//}
//
//struct CountdownView: View {
//    @State private var counter: Int = 0
//    @State private var countTo: Int = 120
//    @State private var isRunning: Bool = false
//    
//    // Time picker states
//    @State private var selectedHours: Int = 0
//    @State private var selectedMinutes: Int = 0
//    @State private var selectedSeconds: Int = 0
//    @State private var showingPicker: Bool = false
//    @State private var title: String = "Yoga" // Initialize with an empty string
//    
//    var body: some View {
//        VStack {
//            // Title text field
//            HStack(spacing:170){
//                    Text(title)
//                        .font(.system(size: 30))
//                        .foregroundColor(.white)
//                    RoundedRectangle(cornerRadius: 30)
//                        .fill(.white)
//                        .frame(width: 130,height: 50)
//                        .overlay(Text("Save")
//                            .foregroundColor(.black))
//                }
//            
//            
//            ZStack {
//                ProgressTrack()
//                ProgressBar(counter: counter, countTo: countTo)
//                
//                if showingPicker {
//                    // Show Picker when the user taps "Change"
//                    VStack(spacing: 20) {
//                        HStack {
//                            Picker("Hours", selection: $selectedHours) {
//                                ForEach(0..<24, id: \.self) {
//                                    Text("\($0) h")
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 80)
//                            
//                            Picker("Minutes", selection: $selectedMinutes) {
//                                ForEach(0..<60, id: \.self) {
//                                    Text("\($0) m")
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 80)
//                            
//                            Picker("Seconds", selection: $selectedSeconds) {
//                                ForEach(0..<60, id: \.self) {
//                                    Text("\($0) s")
//                                }
//                            }
//                            .pickerStyle(.wheel)
//                            .frame(width: 80)
//                        }
//                        Button("Set Time") {
//                            let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
//                            countTo = totalSeconds
//                            counter = 0
//                            isRunning = false
//                            showingPicker = false // Hide picker after setting time
//                        }
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(5)
//                    }
//                    .padding()
//                } else {
//                    VStack {
//                        Clock(counter: counter, countTo: countTo)
//                        Button("Change") {
//                            showingPicker.toggle() // Show or hide picker when tapped
//                        }
//                        .padding()
//                        .background(Color(red:243/255,green: 243/255,blue: 243/255.0))
//                        .foregroundColor(.black)
//                        .cornerRadius(5)
//                    }
//                }
//            }
//            .padding()
//            
//            Spacer()
//            
//            if title.lowercased() == "yoga" {
//                Image("Yoga")
//                    .resizable()
//                    .scaledToFit()
//                    .padding()
//            } else if title.lowercased() == "meditation" {
//                Image("meditation")
//                    .resizable()
//                    .scaledToFit()
//                    .padding()
//            }
//            
//            HStack(spacing: 20) {
//                Button(action: startTimer) {
//                    Text("Start")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                
//                Button(action: stopTimer) {
//                    Text("Stop")
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                
//                Button(action: resumeTimer) {
//                    Text("Resume")
//                        .padding()
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//        }
//        .onReceive(timer) { _ in
//            if isRunning && counter < countTo {
//                counter += 1
//            }
//        }
//    }
//    
//    // Timer control methods
//    func startTimer() {
//        isRunning = true
//        counter = 0
//    }
//    
//    func stopTimer() {
//        isRunning = false
//    }
//    
//    func resumeTimer() {
//        isRunning = true
//    }
//}
//
//struct CountdownView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountdownView()
//    }
//}
