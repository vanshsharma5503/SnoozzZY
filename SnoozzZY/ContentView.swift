//
//  ContentView.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 14/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                ExerciseView()
                    .tabItem {
                        Label("Exercise", systemImage: "gear")
                    }
                    .tag(1)
                
                AlarmListView()
                    .tabItem {
                        Label("Alarm", systemImage: "person")
                    }
                    .tag(2)
            }
            .accentColor(.clear) // Hide the default tab bar accent color
            
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20) // Adjust padding as needed
                .shadow(radius: 10) // Add shadow for floating effect
        }.navigationBarBackButtonHidden(true)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabItems = ["Home", "Exercise", "Alarm"]
    
    var body: some View {
        HStack {
            ForEach(0..<tabItems.count) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    Text(tabItems[index])
                        .font(.headline)
                        .foregroundColor(selectedTab == index ? .white : .gray)
                        .padding()
                        .background(
                            ZStack {
                                if selectedTab == index {
                                    Color(red: 224/255, green: 170/255, blue: 255/255)
                                        .clipShape(Rectangle())
                                        .frame(width: 80, height: 40)
                                        .offset(y: 0)
                                        .cornerRadius(20)// Adjust as needed
                                }
                            }
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(red:60/255,green: 9/255,blue: 108/255.0).opacity(0.8)) // Background color of the tab bar
        .cornerRadius(20) // Rounded corners for the tab bar
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

