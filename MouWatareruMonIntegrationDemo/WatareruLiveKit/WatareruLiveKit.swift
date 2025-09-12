//
//  WatareruLiveKit.swift
//  WatareruLiveKit
//
//  Created by a on 9/12/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration)
  }
  
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    return Timeline(entries: entries, policy: .atEnd)
  }
  
  //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct WatareruLiveKitEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    let signalStatus = getSignalState(at: entry.date)
    
    VStack(spacing: 4) {
      HStack {
        Circle()
          .fill(signalStatus.state == "青信号" ? Color.green : Color.red)
          .frame(width: 12, height: 12)
        Text(signalStatus.state)
          .font(.caption)
          .fontWeight(.semibold)
        Spacer()
      }
      
      HStack {
        Text("残り")
          .font(.caption2)
          .foregroundColor(.secondary)
        Text("\(signalStatus.remainingTime)秒")
          .font(.headline)
          .fontWeight(.bold)
        Spacer()
      }
      
      Text(entry.configuration.favoriteEmoji)
        .font(.title2)
    }
    .padding(.horizontal, 8)
  }
}

struct WatareruLiveKit: Widget {
  let kind: String = "WatareruLiveKit"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      WatareruLiveKitEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
  }
}

extension ConfigurationAppIntent {
  fileprivate static var smiley: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteEmoji = "🚦"
    return intent
  }
  
  fileprivate static var starEyes: ConfigurationAppIntent {
    let intent = ConfigurationAppIntent()
    intent.favoriteEmoji = "🚶"
    return intent
  }
}

#Preview(as: .systemSmall) {
  WatareruLiveKit()
} timeline: {
  SimpleEntry(date: .now, configuration: .smiley)
  SimpleEntry(date: .now, configuration: .starEyes)
}
