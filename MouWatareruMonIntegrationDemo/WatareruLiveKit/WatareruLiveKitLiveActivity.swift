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
    // Dynamic stateful properties about your activity go here!
    var emoji: String
  }
  
  // Fixed non-changing properties about your activity go here!
  var name: String
}

struct WatareruLiveKitLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: WatareruLiveKitAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text("Hello \(context.state.emoji)")
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)
      
    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.leading) {
          Text("Leading")
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text("Trailing")
        }
        DynamicIslandExpandedRegion(.bottom) {
          Text("Bottom \(context.state.emoji)")
          // more content
        }
      } compactLeading: {
        Text("L")
      } compactTrailing: {
        Text("T \(context.state.emoji)")
      } minimal: {
        Text(context.state.emoji)
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

extension WatareruLiveKitAttributes {
  fileprivate static var preview: WatareruLiveKitAttributes {
    WatareruLiveKitAttributes(name: "World")
  }
}

extension WatareruLiveKitAttributes.ContentState {
  fileprivate static var smiley: WatareruLiveKitAttributes.ContentState {
    WatareruLiveKitAttributes.ContentState(emoji: "😀")
  }
  
  fileprivate static var starEyes: WatareruLiveKitAttributes.ContentState {
    WatareruLiveKitAttributes.ContentState(emoji: "🤩")
  }
}

#Preview("Notification", as: .content, using: WatareruLiveKitAttributes.preview) {
  WatareruLiveKitLiveActivity()
} contentStates: {
  WatareruLiveKitAttributes.ContentState.smiley
  WatareruLiveKitAttributes.ContentState.starEyes
}
