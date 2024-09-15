//
//  OnboaringView.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 15/09/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView { // Wrap the view in a NavigationView
            ZStack {
                Background()
                VStack {
                    Spacer()
                    
                    // Display different content based on the currentPage index
                    if currentPage == 0 {
                        OnboardingPageView(imageName: "o1", title: "Welcome", description: "Discover how we can improve your sleep health.")
                    } else if currentPage == 1 {
                        OnboardingPageView(imageName: "o2", title: "Track Sleep", description: "Log and analyze your sleep patterns with ease.")
                    } else if currentPage == 2 {
                        OnboardingPageView(imageName: "o3", title: "Manage Sleep Apnea", description: "Tools to help manage your sleep apnea symptoms.")
                    } else if currentPage == 3 {
                        OnboardingPageView(imageName: "o4", title: "Mental Health Support", description: "Find resources to support your mental health.")
                    }
                    
                    Spacer()
                    
                    // Next/Skip buttons
                    HStack {
                        if currentPage < 3 {
                            Button(action: {
                                currentPage = 3 // Skip to the last page
                            }) {
                                Text("Skip")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        
                        Spacer()
                        
                        // Navigate to ContentView when 'Get Started' is pressed
                        if currentPage == 3 {
                            NavigationLink(destination: ContentView()) { // Navigate to ContentView
                                Text("Get Started")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                                    .cornerRadius(8)
                            }
                            .padding()
                        } else {
                            Button(action: {
                                if currentPage < 3 {
                                    currentPage += 1
                                }
                            }) {
                                Text("Next")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 224/255, green: 170/255, blue: 255/255))
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct OnboardingPageView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 300)
                .padding(.bottom, 20)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .foregroundColor(.white)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.white)
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
