//
//  WatareruLiveKitLiveActivity.swift
//  WatareruLiveKit
//
//  Created by a on 9/12/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WatareruLiveKitAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var signalState: String
    var signalEndTime: Date
    var location: String
    var advice: String
  }
  
  var universityName: String
}

struct WatareruLiveKitLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: WatareruLiveKitAttributes.self) { context in
      VStack(spacing: 8) {
        HStack {
          Circle()
            .fill(context.state.signalState == "青信号" ? Color.green : Color.red)
            .frame(width: 20, height: 20)
          Text(context.state.signalState)
            .font(.headline)
            .fontWeight(.bold)
          Spacer()
          Text(context.state.signalEndTime, style: .timer)
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.trailing)
        }
        
        HStack {
          Text(context.state.location)
            .font(.caption)
            .foregroundColor(.secondary)
          Spacer()
        }
        
        Text(context.state.advice)
          .font(.callout)
          .multilineTextAlignment(.center)
          .padding(.top, 4)
      }
      .padding()
      .activityBackgroundTint(Color.blue.opacity(0.1))
      .activitySystemActionForegroundColor(Color.primary)
      
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .leading) {
            Circle()
              .fill(context.state.signalState == "青信号" ? Color.green : Color.red)
              .frame(width: 16, height: 16)
            Text(context.state.signalState)
              .font(.caption)
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .trailing) {
            Text(context.state.signalEndTime, style: .timer)
              .font(.title3)
              .fontWeight(.bold)
              .multilineTextAlignment(.trailing)
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack {
            Text(context.state.location)
              .font(.caption2)
              .foregroundColor(.secondary)
            Text(context.state.advice)
              .font(.caption)
              .multilineTextAlignment(.center)
          }
        }
      } compactLeading: {
        Circle()
          .fill(context.state.signalState == "青信号" ? Color.green : Color.red)
          .frame(width: 16, height: 16)
      } compactTrailing: {
        Text(context.state.signalEndTime, style: .timer)
          .font(.caption)
          .fontWeight(.bold)
          .multilineTextAlignment(.trailing)
      } minimal: {
        Circle()
          .fill(context.state.signalState == "青信号" ? Color.green : Color.red)
          .frame(width: 16, height: 16)
      }
      .widgetURL(URL(string: "himasuihi://signal"))
      .keylineTint(Color.blue)
    }
  }
}

extension WatareruLiveKitAttributes {
  fileprivate static var preview: WatareruLiveKitAttributes {
    WatareruLiveKitAttributes(universityName: "KINKY UNIVERSITY")
  }
}

extension WatareruLiveKitAttributes.ContentState {
  fileprivate static var greenSignal: WatareruLiveKitAttributes.ContentState {
    WatareruLiveKitAttributes.ContentState(
      signalState: "青信号",
      signalEndTime: Date().addingTimeInterval(25),
      location: "E館エントランス",
      advice: "歩いて間に合います"
    )
  }
  
  fileprivate static var redSignal: WatareruLiveKitAttributes.ContentState {
    WatareruLiveKitAttributes.ContentState(
      signalState: "赤信号",
      signalEndTime: Date().addingTimeInterval(85),
      location: "B館エントランス",
      advice: "早歩きを推奨します"
    )
  }
}

#Preview("Notification", as: .content, using: WatareruLiveKitAttributes.preview) {
  WatareruLiveKitLiveActivity()
} contentStates: {
  WatareruLiveKitAttributes.ContentState.greenSignal
  WatareruLiveKitAttributes.ContentState.redSignal
}
