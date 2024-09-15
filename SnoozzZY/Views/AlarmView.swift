//
//  AlarmView.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 15/09/24.
//

import SwiftUI

// Alarm Model
struct Alarm: Identifiable {
    var id = UUID()
    var time: Date
    var label: String
}

// Alarm Row View
import SwiftUI

// Alarm Row View
struct AlarmRow: View {
    var alarm: Alarm
    
    var body: some View {
        HStack {
            Text(alarm.label)
                .font(.body) // Adjust font size if needed
            
            Spacer()
            
            Text("\(alarm.time, formatter: dateFormatter)")
                .font(.body) // Adjust font size if needed
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding(.vertical, 4) // Add some vertical padding for better spacing
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

// Previews
struct AlarmRow_Previews: PreviewProvider {
    static var previews: some View {
        AlarmRow(alarm: Alarm(time: Date(), label: "Morning Alarm"))
            .previewLayout(.sizeThatFits)
    }
}


// Alarm List View
struct AlarmListView: View {
    @State private var alarms: [Alarm] = []
    @State private var showingAddAlarm = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Background()
                
                VStack {
                    HStack {
                        Text("Alarms")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding() // Add padding around the title
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddAlarm = true
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white) 
                                .font(.system(size: 30))// Ensure the button is visible against the background
                                .padding()
                        }
                    }
                    
                    ScrollView { // Use ScrollView to ensure content can be scrolled if it overflows
                        VStack(alignment: .leading) {
                            ForEach(alarms) { alarm in
                                AlarmRow(alarm: alarm)
                            }
                        }
                        .padding(.horizontal) // Add horizontal padding to avoid content touching screen edges
                    }
                }
                .navigationBarHidden(true) // Hide the default navigation bar
                .sheet(isPresented: $showingAddAlarm) {
                    AddAlarmView(alarms: $alarms)
                }
            }
        }
    }
}

// Add Alarm View
import SwiftUI

// Add Alarm View
struct AddAlarmView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var alarms: [Alarm]
    
    @State private var alarmTime = Date()
    @State private var alarmLabel = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Background()
                
                Form {
                    DatePicker("Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                    TextField("Label", text: $alarmLabel)
                }
                .scrollContentBackground(.hidden) // Ensure background color shows through
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Add Alarm")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newAlarm = Alarm(time: alarmTime, label: alarmLabel)
                        alarms.append(newAlarm)
                        dismiss()
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.white) // Set button color to white
                }
            }
        }
    }
}

// Previews
struct AddAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AddAlarmView(alarms: .constant([]))
    }
}

// Previews
struct AlarmListView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmListView()
    }
}
