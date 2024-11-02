//
//  ContentView.swift
//  BetterRest
//
//  Created by Saverio Negro on 30/10/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    @State private var wakeUp: Date = ContentView.defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    
    func calculateBedtime() {
        do {
            
            // Instantiate the model
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // Work out Inputs
            let wakeUpInSeconds = getWakeUpTimeInSeconds()
            let coffeeAmount = Double(coffeeAmount)
            
            // Get prediction
            let prediction = try model.prediction(input: .init(wake: wakeUpInSeconds, estimatedSleep: sleepAmount, coffee: coffeeAmount))
            
            // Get sleep time as a `Date` object
            let sleepTime = wakeUp - prediction.actualSleep
            
            // Get string representation of `Date` object
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "h:mm a"
            let sleepTimeString = dateFormatter.string(from: sleepTime)
            
            // Set the title and message for the alert
            alertTitle = "Your ideal bedtime is:"
            alertMessage = sleepTimeString
            
        } catch {
            // Generate an error message in case the prediction fails
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        isShowingAlert = true
    }
    
    func getWakeUpTimeInSeconds() -> Double {
        let components = Calendar.current.dateComponents(Set([Calendar.Component.hour, Calendar.Component.minute]), from: wakeUp)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let wakeUpTimeInSeconds = (hours * 3600) + (minutes * 60)
        return Double(wakeUpTimeInSeconds)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                // UI for wake up time
                Section("When do you want to wake up?") {
                    DatePicker("Please, enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                // UI for hours of sleep
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                // UI for cups of coffee per day
                Section("Daily coffee intake") {
//                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(0..<21) { num in
                            if num != 0 {
                                Text("^[\(num) cup](inflect: true)")
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                // UI for displaying the predicted bedtime
                Section(alertTitle) {
                    Text(alertMessage)
                        .font(.largeTitle)
                }
            }
            .navigationTitle("BetterRest")
            .onAppear {
                calculateBedtime()
            }
            .onChange(of: wakeUp) {
                calculateBedtime()
            }
            .onChange(of: sleepAmount) {
                calculateBedtime()
            }
            .onChange(of: coffeeAmount) {
                calculateBedtime()
            }
//            .toolbar {
//                Button("Calculate") {
//                    calculateBedtime()
//                }
//            }
//            .alert(alertTitle, isPresented: $isShowingAlert) {
//                Button("OK", role: .destructive) {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
}

#Preview {
    ContentView()
}
