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
    private var tomorrow: Date {
        /// Return a `Date` instance set to one day (in seconds) fro now
        return Date.now.addingTimeInterval(86400)
    }
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted(.number)) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("Please, enter a date.", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
