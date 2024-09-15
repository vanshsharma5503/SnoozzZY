//
//  HomeVIew.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 15/09/24.
//
import SwiftUI
import HealthKit

// Model to store sleep diary data
struct SleepData: Identifiable {
    let id = UUID()
    let sleepTime: Date
    let wakeTime: Date
    let mood: String
    let sleepQuality: String
    let interruptions: String
}

class SleepDiaryStore: ObservableObject {
    @Published var diaryEntries: [SleepData] = []
    
    func addEntry(sleepTime: Date, wakeTime: Date, mood: String, sleepQuality: String, interruptions: String) {
        let newEntry = SleepData(sleepTime: sleepTime, wakeTime: wakeTime, mood: mood, sleepQuality: sleepQuality, interruptions: interruptions)
        diaryEntries.append(newEntry)
    }
}





struct HomeView: View {
    @State private var heartRate: Double = 0.0
    @State private var oxygenLevel: Double = 0.0
    @State private var breathingRate: Double = 0.0
    @State private var showSleepDiary = false
    
    @StateObject private var sleepDiaryStore = SleepDiaryStore()
    
    let username = "Vansh Sharma"
    let profilePicture = "profile_pic" // Add a profile image asset with this name
    let textColor = Color(red: 224/255, green: 170/255, blue: 255/255) // Color of the font as per request

    var body: some View {
        ZStack {
            // Add the background to the screen
            Background()
            
            VStack {
                // Profile Section
                HStack(spacing:30) {
                    if let _ = UIImage(named: profilePicture) {
                        Image(profilePicture)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(username)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(textColor) // Apply the custom text color
                        Text("Welcome back!")
                            .font(.subheadline)
                            .foregroundColor(textColor.opacity(0.7)) // Slightly dimmer text color
                    }
                    
                    Spacer()
                }
                .padding()

                // Health Metrics Section
                VStack(spacing: 20) {
                    HealthMetricView(metricName: "Heart Rate", value: heartRate, unit: "BPM" )
                    HealthMetricView(metricName: "Oxygen Level", value: oxygenLevel, unit: "%")
                    HealthMetricView(metricName: "Breathing Rate", value: breathingRate, unit: "BPM")
                }
                .padding()

                // Sleep Diary Button
                Button(action: {
                    showSleepDiary.toggle()
                }) {
                    Text("Sleep Diary")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(textColor) // Button background matches the text color
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showSleepDiary) {
                    SleepDiaryView(store: sleepDiaryStore)
                }

                Spacer()

                // Footer Section: Display saved sleep entries
                Text("Recent Sleep Entries")
                    .font(.system(size: 30))
                    .foregroundColor(textColor) 
                    .padding(.top,20)// Use the text color here as well
                   
                
                ScrollView {
                    ForEach(sleepDiaryStore.diaryEntries) { entry in
                        ZStack{
                            Rectangle()
                                .fill(.white)
                                .frame(width: 360,height: 150)
                            HStack{
                                Image("sleep").resizable().scaledToFit().frame(width: 50,height: 50)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Sleep Time: \(entry.sleepTime, style: .time)")
                                    Text("Wake Time: \(entry.wakeTime, style: .time)")
                                    Text("Mood: \(entry.mood)")
                                    Text("Quality: \(entry.sleepQuality)")
                                    Text("Interruptions: \(entry.interruptions)")
                                }
                                .padding()
                                .frame(height: 150)
                                .shadow(radius: 2)
                                .cornerRadius(5)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
               
            }
        }
        .onAppear {
            #if !DEBUG
            fetchHealthData()
            #endif
        }
    }
    
    // Fetch health data from HealthKit (same as before)
    func fetchHealthData() {
        let healthStore = HKHealthStore()
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let oxygenLevelType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        let breathingRateType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!

        healthStore.requestAuthorization(toShare: nil, read: [heartRateType, oxygenLevelType, breathingRateType]) { success, error in
            if success {
                fetchLatestData(for: heartRateType) { value in
                    heartRate = value
                }
                fetchLatestData(for: oxygenLevelType) { value in
                    oxygenLevel = value
                }
                fetchLatestData(for: breathingRateType) { value in
                    breathingRate = value
                }
            }
        }
    }
    
    func fetchLatestData(for type: HKQuantityType, completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let sample = samples?.first as? HKQuantitySample {
                completion(sample.quantity.doubleValue(for: .count().unitDivided(by: .minute())))
            }
        }
        healthStore.execute(query)
    }
}

struct HealthMetricView: View {
    var metricName: String
    var value: Double
    var unit: String
     // Pass the text color down

    var body: some View {
        HStack {
            Text(metricName)
                .font(.headline)
                .frame(width: 150, alignment: .leading)
                .foregroundColor(.black) // Apply the custom text color here
            Spacer()
            Text("\(String(format: "%.1f", value)) \(unit)")
                .font(.title)
                .foregroundColor(.black) // Apply the custom text color here
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HomeView()
}

import SwiftUI
import HealthKit

// Custom DatePicker with white text color
struct CustomWheelDatePicker: UIViewRepresentable {
    @Binding var date: Date
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.setValue(UIColor.white, forKey: "textColor")  // Change the text color to white
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }
}

struct SleepDiaryView: View {
    @ObservedObject var store: SleepDiaryStore
    @State private var sleepTime = Date()
    @State private var wakeTime = Date()
    @State private var showSleepTimePicker = false
    @State private var showWakeTimePicker = false
    @State private var mood: Int = 2 // Default to neutral
    private let moods = ["😔", "🙁", "😐", "🙂", "😀"]
    
    @State private var questions: [String: Int] = [
        "How restful was your sleep?": 2,
        "Did you experience any interruptions?": 2
    ]
    
    private let scaleEmojis = ["😔", "🙁", "😐", "🙂", "😀"]
    @Environment(\.dismiss) var dismiss  // To dismiss the sheet

    var body: some View {
        NavigationView {
            ZStack {
                Background()
                VStack(spacing: 20) {
                    // Title
                    Text("Sleep Diary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255)) // Font color update
                        .padding(.top, 20)
                    
                    // Sleep Time Picker Trigger
                    Button(action: {
                        showSleepTimePicker.toggle()
                    }) {
                        HStack {
                            Text("When did you sleep?")
                                .font(.headline)
                                .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255)) // Font color update
                            Spacer()
                            Text("\(formattedTime(sleepTime))")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    // Conditional Sleep Time Picker
                    if showSleepTimePicker {
                        CustomWheelDatePicker(date: $sleepTime) // Custom picker with white text
                            .frame(height: 150)
                            .padding(.horizontal)
                    }

                    // Wake Time Picker Trigger
                    Button(action: {
                        showWakeTimePicker.toggle()
                    }) {
                        HStack {
                            Text("When did you wake up?")
                                .font(.headline)
                                .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255)) // Font color update
                            Spacer()
                            Text("\(formattedTime(wakeTime))")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    // Conditional Wake Time Picker
                    if showWakeTimePicker {
                        CustomWheelDatePicker(date: $wakeTime) // Custom picker with white text
                            .frame(height: 150)
                            .padding(.horizontal)
                    }

                    // Mood Picker
                    VStack {
                        Text("How did you feel about your sleep?")
                            .font(.headline)
                            .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255)) // Font color update
                        HStack {
                            ForEach(0..<moods.count, id: \.self) { index in
                                Text(moods[index])
                                    .font(.largeTitle)
                                    .onTapGesture {
                                        mood = index
                                    }
                                    .padding()
                                    .background(mood == index ? Color(red: 224/255, green: 170/255, blue: 255/255) : Color.white)
                                    .cornerRadius(10)
                            }
                        }
                    }

                    // Additional Questions
                    ForEach(questions.keys.sorted(), id: \.self) { question in
                        VStack {
                            Text(question)
                                .font(.headline)
                                .foregroundColor(Color(red: 224/255, green: 170/255, blue: 255/255)) // Font color update
                            HStack {
                                ForEach(0..<scaleEmojis.count, id: \.self) { index in
                                    Text(scaleEmojis[index])
                                        .font(.largeTitle)
                                        .onTapGesture {
                                            questions[question] = index
                                        }
                                        .padding()
                                        .background(questions[question] == index ? Color(red: 224/255, green: 170/255, blue: 255/255) : Color.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }

                    // Save Button
                    Button("Save") {
                        saveSleepData()
                        dismiss() // Dismiss the sheet after saving
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .cornerRadius(30)
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }
        }
    }
    
    // Helper function to format the time for display
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Function to handle saving the sleep diary data
    func saveSleepData() {
        let moodText = moods[mood]
        let sleepQuality = scaleEmojis[questions["How restful was your sleep?"]!]
        let interruptions = scaleEmojis[questions["Did you experience any interruptions?"]!]
        
        store.addEntry(sleepTime: sleepTime, wakeTime: wakeTime, mood: moodText, sleepQuality: sleepQuality, interruptions: interruptions)
    }
}

#Preview {
    SleepDiaryView(store: SleepDiaryStore()) // Provide a sample store for preview
}


#Preview {
    SleepDiaryView(store: SleepDiaryStore()) // Provide a sample store for preview
}


// Assuming the SleepDiaryStore class looks something like this

// SleepDiaryEntry struct to hold each entry's data
struct SleepDiaryEntry {
    let sleepTime: Date
    let wakeTime: Date
    let mood: String
    let sleepQuality: String
    let interruptions: String
}

#Preview {
    SleepDiaryView(store: SleepDiaryStore())
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
