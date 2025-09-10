//
//  MouWatareruMonApp.swift
//  MouWatareruMon
//
//  Created by 末次淳一 on 2025/09/10.
//

import SwiftUI

@main
struct MouWatareruMonApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        requestNotificationPermission()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
