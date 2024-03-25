//
//  TimerProgrammingView.swift
//  Zafu
//
//  Created by Jacopo Donati on 25/03/24.
//

import SwiftUI

struct TimerProgrammingView: View {
    @EnvironmentObject var timerData: TimerData
    @Binding var isTimerProgrammingViewPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $timerData.selectedHours, label: Text("Select hours")) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) hours").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .frame(width: 100)
                
                Picker(selection: $timerData.selectedMinutes, label: Text("Select minutes")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) minutes").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .frame(width: 100)
            }
            .padding()
            
            Button("Confirm") {
                print(timerData.totalSeconds)
                isTimerProgrammingViewPresented = false
            }
            .padding()
        }
        .navigationTitle("Edit timer")
    }
}
