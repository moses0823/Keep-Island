//
//  TransparentIslandWidget.swift
//  Keep Island
//
//  Created by Moses Yu on 11/21/25.
//
import ActivityKit
import SwiftUI
import WidgetKit
struct IslandAttr: ActivityAttributes {
    struct ContentState: Codable, Hashable {}
}
struct TransparentIslandWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttr.self) { _ in
            Color.clear.frame(height: 1)
        } dynamicIsland: { context in
            DynamicIsland {
                // 展開區域 - 頂部
                DynamicIslandExpandedRegion(.leading) {
                    EmptyView()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()
                }
                // 展開區域 - 中間主要內容
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 16) {
                        Text("Keep Island")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Link(destination: URL(string: "keepisland://stop")!) {
                            HStack {
                                Image(systemName: "stop.circle.fill")
                                Text("停止")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red)
                            )
                        }
                    }
                    .padding(.vertical, 20)
                }
                // 展開區域 - 底部
                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()
                }
            } compactLeading: {
                Image(systemName: "circle.fill")
                    .foregroundColor(.clear)
                    .frame(width: 1, height: 1)
            } compactTrailing: {
                Image(systemName: "circle.fill")
                    .foregroundColor(.clear)
                    .frame(width: 1, height: 1)
            } minimal: {
                Image(systemName: "circle.fill")
                    .foregroundColor(.clear)
                    .frame(width: 1, height: 1)
            }
        }
    }
}
