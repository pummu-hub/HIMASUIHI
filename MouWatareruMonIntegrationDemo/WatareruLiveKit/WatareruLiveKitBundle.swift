//
//  WatareruLiveKitBundle.swift
//  WatareruLiveKit
//
//  Created by a on 9/12/25.
//

import WidgetKit
import SwiftUI

@main
struct WatareruLiveKitBundle: WidgetBundle {
  var body: some Widget {
    WatareruLiveKit()
    WatareruLiveKitControl()
    WatareruLiveKitLiveActivity()
  }
}
