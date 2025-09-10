//
//  Notification.swift
//  MouWatareruMon
//
//  Created by 末次淳一 on 2025/09/09.
//

import Foundation
import UserNotifications

/// 次の信号までの残り時間を表示する、即時送信される通知を作成し追加する。（未完成）
/// - Parameters:
///   - nextTrafficColor: 表示したい次の信号色
///   - timeSecDelay: 表示したい次の信号までの残り時間（秒）
func sendTrafficNotification(nextTrafficColor: String, timeSecDelay: Double) {
    print("次の信号までの残り時間通知が送信されました")
    let content = UNMutableNotificationContent()
    content.title = "信号のお知らせ"
    content.body = "🚦\(nextTrafficColor)まで 後 \(Int(timeSecDelay))秒です"
    content.badge = 1
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

    // 通知リクエストを作成して登録する
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        if granted {
            print("通知が許可された(^_^)")
        } else {
            print("通知が拒否された(>_<)")
        }
    }
}
