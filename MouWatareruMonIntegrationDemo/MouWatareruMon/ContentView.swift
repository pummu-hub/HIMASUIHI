//
//  ContentView.swift
//  WatareruMon
//　メインUIコード
//  Created by 槇原 陸斗 on 2025/09/07.
//

import SwiftUI
import ActivityKit


struct ContentView: View {
    @State private var selectionValue: String? = nil
    @State private var secondsUntilChangeDisplay: Int = 0 // 表示したい次の信号までの時間を保持する変数
    @State private var nextTrafficColorDisplay: String = "" // 表示したい次の信号色を表す文字列を保持する変数
    @State private var isNotificationOn = false // 残り時間の通知機能を切り替えるためのフラグ
    @StateObject private var weatherManager = WeatherManager()
    private var notificationTimingSec = 10 // 信号が変わる何秒前に通知するかを設定する変数
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
    @State private var activity: Activity<WatareruLiveKitAttributes>?

    
    var body: some View {
        
        
        ZStack {
            //全体背景の色設定
            Color(.secondarySystemBackground)
            
            //ここからUIの設置
            VStack {
                
                Toggle(isOn: $isNotificationOn) {
                    Text("信号が変わる\(notificationTimingSec)秒前に通知")
                }
                ZStack {
                    //信号機を模した図形の背景
                    //ここのカラーを信号が青の時は緑、赤の時は赤色にする
                    RoundedRectangle(cornerRadius: 20)
                        .fill(nextTrafficColorDisplay == "赤信号" ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                        .frame(width: 400, height: 400)
                    
                    //ここから信号機の図形配置
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.86))
                            .frame(width: 210, height: 350)
                        
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 170, height: 130)
                                
                                //人のアイコン配置
                                Image(systemName: "figure.stand")
                                    .resizable()
                                    .frame(width: 42, height: 100)
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.86))
                                .frame(width: 210, height: 15)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 170, height: 130)
                                
                                //人のアイコン配置
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .frame(width: 58, height: 100)
                            }
                        }
                    }
                    
                    
                }
                Text("今いる場所を選択してください\(selectionValue ?? "")")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                
                //今いる場所の選択肢リスト　"どれか押すと今いる場所を選択してください"の1行下に押した選択肢が表示される
                //ここのtagから今いる場所を取得して"早歩き推奨"か"歩き推奨"かを判別できると思います
                List(selection: $selectionValue) {
                    Text("E館エントランス").tag("\nE館エントランス")
                    Text("B館エントランス").tag("\nB館エントランス")
                    Text("November食堂前").tag("\nNovember食堂前")
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
                
                //全体背景色と同じframeを用いて文字を書くところを調整している
                ZStack {
                    Color(.secondarySystemBackground).frame(width: 400, height: 100)
                    
                    //文字の位置調整用
                    VStack{
                        //この"赤"を青と赤を管理している変数に、"60"をカウントしている変数に置き換えお願いします
                        Text("次\(nextTrafficColorDisplay)になるまで：\(secondsUntilChangeDisplay)秒")
                            .font(.system(size: 25)).onReceive(timer) { _ in
                                nextTrafficColorDisplay = "青信号" == TimeCalculator().status.state ? "赤信号" : "青信号"
                                secondsUntilChangeDisplay = TimeCalculator().status.remainingTime
                                
                                if secondsUntilChangeDisplay == notificationTimingSec && isNotificationOn {
                                    sendTrafficNotification(
                                        nextTrafficColor: nextTrafficColorDisplay,
                                        timeSecDelay: notificationTimingSec
                                    )
                                }
                            }
                        
                        //このTextを変えればいいと思います（歩きで間に合います, 早歩きを推奨しますetc...）
                        Text(generateCombinedAdvice(location: selectionValue, weather: weatherManager.condition, signal: TimeCalculator().status))
                            .font(.system(size: 30))
                        
                        //文字の位置調整用のframe
                        Color(.secondarySystemBackground).frame(width: 400, height: 28)
                    }
                    
                }
                .onAppear {
                    weatherManager.fetchWeather(for: "Tokyo") {
                        print("天気取得完了: \(weatherManager.condition)")
                    }
                }
            }
            
            .onAppear {
                startSignalActivity()
            }
            .onReceive(timer) { _ in
                updateSignalActivity()
            }
        }
    }
    
  func startSignalActivity() {
    let attrs = WatareruLiveKitAttributes(universityName: "近畿大学")
    let signalStatus = TimeCalculator().status
    let currentLocation = selectionValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "未選択"
    let advice = generateCombinedAdvice(location: selectionValue, weather: weatherManager.condition, signal: signalStatus)
    
    let state = WatareruLiveKitAttributes.ContentState(
      signalState: signalStatus.state,
      remainingTime: signalStatus.remainingTime,
      location: currentLocation,
      advice: advice
    )
    let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(60))
    
    do {
      activity = try Activity.request(
        attributes: attrs,
        content: content,
        pushType: nil
      )
    } catch {
      print("Live Activity request failed:", error)
    }
  }
  
  func updateSignalActivity() {
    guard let activity = activity else { return }
    
    let signalStatus = TimeCalculator().status
    let currentLocation = selectionValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "未選択"
    let advice = generateCombinedAdvice(location: selectionValue, weather: weatherManager.condition, signal: signalStatus)
    
    let updatedState = WatareruLiveKitAttributes.ContentState(
      signalState: signalStatus.state,
      remainingTime: signalStatus.remainingTime,
      location: currentLocation,
      advice: advice
    )
    
    let content = ActivityContent(state: updatedState, staleDate: Date().addingTimeInterval(60))
    
    Task {
      await activity.update(content)
    }
  }
    
//    #Preview {
//        ContentView()
//    }
    
    
    func generateCombinedAdvice(location: String?, weather: String, signal: SignalStatus) -> String {
        guard let location = location else {
            return "場所を選択してください"
        }
        
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch trimmedLocation {
        case "E館エントランス":
            switch weather {
            case "Rain", "Snow":
                if signal.state == "青信号" && signal.remainingTime >= 10 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 80 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
                
            case "Clear":
                if signal.state == "青信号" && signal.remainingTime >= 5 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 75 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
                
            default:
                if signal.state == "青信号" && signal.remainingTime >= 7 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 77 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
            }
        case "B館エントランス":
            switch weather {
            case "Rain", "Snow":
                if signal.state == "青信号" && signal.remainingTime >= 20 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 10 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
                
            case "Clear":
                if signal.state == "青信号" && signal.remainingTime >= 15 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 5 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
                
            default:
                if signal.state == "青信号" && signal.remainingTime >= 17 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 7 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
            }
            
        case "November食堂前":
            switch weather {
            case "Rain", "Snow":
                if signal.state == "青信号" && signal.remainingTime >= 23 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 10 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
            case "Clear":
                if signal.state == "青信号" && signal.remainingTime >= 18 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 5 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
            default:
                if signal.state == "青信号" && signal.remainingTime >= 20 {
                    return "歩いて間に合います"
                } else if signal.state == "赤信号" && signal.remainingTime >= 8 {
                    return "歩いて間に合います"
                } else {
                    return "早歩きを推奨します"
                }
            }
            
        default:
            return "場所を選択してください"
        }
    }
}
