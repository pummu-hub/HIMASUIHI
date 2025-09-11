//
//  TimeCalculator.swift
//  SignalApp
//
//  Created by れおう on 2025/09/04.
//
import Foundation

struct SignalStatus { //信号の状態
    let state: String       //青or赤
    let remainingTime: Int  //次の信号までの時間
    let phase: Int          //現在の位相
    let cycle: Int          //周期
}

func getSignalState(at date: Date) -> String {
    let calendar = Calendar.current
    calendar.timeZone = TimeZone.current
        
    // 基準日時：2025年9月6日（土）12:00:00
    let baseComponents = DateComponents(year: 2025, month: 9, day: 6, hour: 12, minute: 0, second: 0)
    guard let baseDate = calendar.date(from: baseComponents) else {
        return "エラー: 基準日時を生成できませんでした"
    }
    
    //1日あたりのズレ
    let dailyDrift: TimeInterval = 38
    
    //経過秒数
    let elapsedSeconds = date.timeIntervalSince(baseDate)
    
    let elapsedDays = Int(floor(elapsedSeconds / 86400))
    
    let totalDrift = TimeInterval(elapsedDays) * dailyDrift
    
    let effectiveElapsedSeconds = elapsedSeconds + totalDrift
    
    //曜日・時間取得
    let weekday = calendar.component(.weekday, from: date)
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    let second = calendar.component(.second, from: date)
    
    let isWeekend = (weekday == 1) || (weekday == 7)
    
    var cycleDuration: TimeInterval = 120
    var greenDuration: TimeInterval = 30
    
    if isWeekend {
        cycleDuration = 110
        greenDuration = 25
    } else {
        cycleDuration = 120
        greenDuration = 30
    }
    
    let phase = effectiveElapsedSeconds.truncatingRemainder(dividingBy: cycleDuration)
    
    let state: String
    let remainingTime: Int
    
    if phase < greenDuration {
        state = "青"
        remainingTime: Int(ceil(greenDuration - phase))
    } else {
        state = "赤"
        remainingTime: Int(ceil(cycleDuration - phase))
    }
        
    return SignalStatus(
        state: state,
        remainingTime: remainingTime,
        phase: Int(phase),
        cycle: Int(cycleDuration)
    )
}
//時間計算
class TimeCalculator {
    let now = Date()
    let status = getSignalState(at: now)
}
