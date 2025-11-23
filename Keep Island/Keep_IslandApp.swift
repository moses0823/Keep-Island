//
//  Keep_IslandApp.swift
//  Keep Island
//
//  Created by Moses Yu on 11/21/25.
//
import SwiftUI
import ActivityKit
@main
struct KeepIslandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
struct ContentView: View {
    @ObservedObject var manager = ActivityManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Keep Island")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if manager.isRunning {
                Text("● 運行中")
                    .foregroundColor(.green)
                    .font(.headline)
                
                Button(action: {
                    manager.stop()
                }) {
                    Text("停止")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            } else {
                Text("● 未運行")
                    .foregroundColor(.gray)
                    .font(.headline)
                
                Button(action: {
                    manager.start()
                }) {
                    Text("啟動")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .onAppear {
            // 每次打開 App 都重新檢查狀態
            manager.checkExistingActivity()
        }
    }
}
