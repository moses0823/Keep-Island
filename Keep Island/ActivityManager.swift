//
//  ActivityManager.swift
//  Keep Island
//
//  Created by Moses Yu on 11/21/25.
//
import Foundation
import ActivityKit
import UIKit
import Combine
class ActivityManager: ObservableObject {
    static let shared = ActivityManager()
    @Published var isRunning: Bool = false
    private var activity: Activity<IslandAttr>?
    
    private init() {
        checkExistingActivity()
    }
    
    func checkExistingActivity() {
        // 檢查是否有正在運行的 Activity
        let activities = Activity<IslandAttr>.activities
        if let existingActivity = activities.first {
            activity = existingActivity
            isRunning = true
            print("✅ 找到現有 Activity: \(existingActivity.id)")
        } else {
            activity = nil
            isRunning = false
            print("ℹ️ 沒有運行中的 Activity")
        }
    }
    func start() {
        // Check if activity already exists
        if activity != nil {
            print("Activity already running")
            return
        }
        
        // Debug: Print app state
        let appState = UIApplication.shared.applicationState
        print("📱 Current app state: \(appState.rawValue) (0=active, 1=inactive, 2=background)")
        
        // Check if Live Activities are supported
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities are not enabled")
            return
        }
        let attr = IslandAttr()
        let state = IslandAttr.ContentState()
        do {
            let content = ActivityContent(state: state, staleDate: nil)
            activity = try Activity<IslandAttr>.request(
                attributes: attr,
                content: content,
                pushType: nil
            )
            isRunning = true
            print("✅ Activity started: \(activity?.id ?? "unknown")")
        } catch {
            print("❌ Failed to start activity: \(error.localizedDescription)")
            isRunning = false
            
            // Check specific error messages
            let errorMessage = error.localizedDescription.lowercased()
            if errorMessage.contains("foreground") {
                print("   → Solution: Make sure to call start() from a button tap or user action")
            } else if errorMessage.contains("enabled") {
                print("   → Solution: Enable Live Activities in Settings")
            }
        }
    }
    func update(state: IslandAttr.ContentState) {
        guard let activity = activity else {
            print("No active activity to update")
            return
        }
        
        Task {
            let content = ActivityContent(state: state, staleDate: nil)
            await activity.update(content)
        }
    }
    func stop() {
        guard let activity = activity else {
            print("No active activity to stop")
            return
        }
        
        Task {
            let finalContent = ActivityContent(
                state: activity.content.state,
                staleDate: nil
            )
            await activity.end(finalContent, dismissalPolicy: .immediate)
            self.activity = nil
            self.isRunning = false
            print("Activity stopped")
        }
    }
    
    func stopAfterDelay(seconds: TimeInterval = 4) {
        guard let activity = activity else { return }
        
        Task {
            let finalContent = ActivityContent(
                state: activity.content.state,
                staleDate: nil
            )
            await activity.end(finalContent, dismissalPolicy: .after(Date().addingTimeInterval(seconds)))
            self.activity = nil
            self.isRunning = false
        }
    }
}
