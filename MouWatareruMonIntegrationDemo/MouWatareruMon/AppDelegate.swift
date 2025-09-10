//
//  AppDelegate.swift
//  MouWatareruMon
//
//  Created by 末次淳一 on 2025/09/10.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // 通知のデリゲートを設定
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // アラート、サウンド、バッジのすべてを表示する場合
        completionHandler([.banner, .list, .sound, .badge])
    }
}
