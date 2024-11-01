//
//  ContentView.swift
//  BetterRest
//
//  Created by Saverio Negro on 30/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp: Date = Date.now
    @State private var actualSleepDate: Date = Date.now
    var defaultWakeUp: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted(.number)) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("Please, enter a date.", selection: $wakeUp, displayedComponents: .hourAndMinute)
                .labelsHidden()
            HStack {
                Text("You should sleep at")
                Text(actualSleepDate, format: .dateTime.hour().minute())
            }
        }
        .padding()
        .onAppear {
            wakeUp = defaultWakeUp
            print(wakeUp)
        }
        .onChange(of: wakeUp) { oldValue, newValue in
            
            let components = Calendar.current.dateComponents(Set([.hour, .minute]), from: wakeUp)
            let chosenHour = components.hour ?? 0
            let chosenMinute = components.minute ?? 0
            
            print(chosenHour)
            print(chosenMinute)
        }
    }
}

#Preview {
    ContentView()
}
