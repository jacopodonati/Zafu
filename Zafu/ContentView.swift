//
//  ContentView.swift
//  Zafu
//
//  Created by Jacopo Donati on 17/02/24.
//

import SwiftUI
import SwiftData

class TimerData: ObservableObject {
    @Published var selectedHours: Int = 0 {
        didSet {
            updateTotalSeconds()
        }
    }
    @Published var selectedMinutes: Int = 15 {
        didSet {
            updateTotalSeconds()
        }
    }
    @Published var totalSeconds: Int = 0
    
    init() {
        updateTotalSeconds()
    }
    
    func updateTotalSeconds() {
        totalSeconds = (selectedHours * 60 + selectedMinutes) * 60
    }
}

struct ContentView: View {
    @State private var totalSecondsElapsed = 0
    @State private var totalSecondsRemaining: Int
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var isTimerProgrammingViewPresented = false
    @EnvironmentObject var timerData: TimerData
    
    init(timerData: TimerData) {
        _totalSecondsRemaining = State(initialValue: timerData.totalSeconds)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CountdownTimerView(totalSecondsRemaining: $totalSecondsRemaining)
                TimerView(totalSeconds: $totalSecondsElapsed)
                TimerControlsView(
                    totalSecondsRemaining: $totalSecondsRemaining,
                    totalSecondsElapsed: $totalSecondsElapsed,
                    isTimerRunning: $isTimerRunning,
                    timer: $timer,
                    isTimerProgrammingViewPresented: $isTimerProgrammingViewPresented
                )
            }
            .padding()
            .navigationBarItems(trailing: Button("Edit") {
                print(timerData.totalSeconds)
                isTimerProgrammingViewPresented = true
            })
            .environmentObject(timerData)
            .sheet(isPresented: $isTimerProgrammingViewPresented, onDismiss: {
                timerData.updateTotalSeconds()
            }) {
                TimerProgrammingView(isTimerProgrammingViewPresented: $isTimerProgrammingViewPresented)
                    .environmentObject(timerData)
            }
        }
    }
}

struct CountdownTimerView: View {
    @Binding var totalSecondsRemaining: Int
    
    var body: some View {
        let hours = totalSecondsRemaining / 3600
        let minutes = (totalSecondsRemaining % 3600) / 60
        let seconds = totalSecondsRemaining % 60
        
        Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
            .font(.title)
    }
}

struct TimerView: View {
    @Binding var totalSeconds: Int
    
    var body: some View {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
            .font(.title)
    }
}

struct TimerControlsView: View {
    @Binding var totalSecondsRemaining: Int
    @Binding var totalSecondsElapsed: Int
    @Binding var isTimerRunning: Bool
    @Binding var timer: Timer?
    @Binding var isTimerProgrammingViewPresented: Bool
    @EnvironmentObject var timerData: TimerData
    
    var body: some View {
        HStack {
            Button(action: {
                isTimerRunning.toggle()
                if isTimerRunning {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        if totalSecondsRemaining > 0 {
                            totalSecondsRemaining -= 1
                            totalSecondsElapsed += 1
                        } else {
                            timer?.invalidate()
                            isTimerRunning = false
                        }
                    }
                } else {
                    timer?.invalidate()
                }
            }) {
                Text(isTimerRunning ? "Stop": "Start")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(isTimerRunning ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            
            Button(action: {
                totalSecondsRemaining = timerData.totalSeconds
                totalSecondsElapsed = 0
                isTimerRunning = false
                timer?.invalidate()
            }) {
                Text("Reset")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        .onReceive(timerData.$totalSeconds, perform: { newTotalSeconds in
            totalSecondsRemaining = newTotalSeconds
        })
    }
}

#Preview {
    ContentView(timerData: TimerData())
        .modelContainer(for: Item.self, inMemory: true)
        .environment(\.locale, .init(identifier: "it"))
        .environmentObject(TimerData())
}
