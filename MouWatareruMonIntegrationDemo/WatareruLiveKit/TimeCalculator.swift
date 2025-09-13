//
//  TimeCalculator.swift
//  SignalApp
//
//  Created by れおう on 2025/09/04.
//

///TODO: ほんとはCoreターゲットとか作って共通化させたほうがいいけど面倒なのでコピペ

import Foundation

struct SignalStatus {
  let state: String
  let remainingTime: Int
  let phase: Int
  let cycle: Int
  let endTime: Date
}

func getSignalState(at date: Date) -> SignalStatus {
  var calendar = Calendar.current
  calendar.timeZone = TimeZone.current
  
  let baseComponents = DateComponents(year: 2025, month: 9, day: 6, hour: 12, minute: 0, second: 0)
  guard let baseDate = calendar.date(from: baseComponents) else {
    return SignalStatus(state: "不明", remainingTime: 0, phase: 0, cycle: 0, endTime: date)
  }
  
  let dailyDrift: TimeInterval = 38
  
  let elapsedSeconds = date.timeIntervalSince(baseDate)
  
  let elapsedDays = Int(floor(elapsedSeconds / 86400))
  
  let totalDrift = TimeInterval(elapsedDays) * dailyDrift
  
  let effectiveElapsedSeconds = elapsedSeconds + totalDrift
  
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
  
  let state = phase < greenDuration ? "青信号" : "赤信号"
  let remainingTime = phase < greenDuration
  ? Int(ceil(greenDuration - phase))
  : Int(ceil(cycleDuration - phase))
  
  let endTime = date.addingTimeInterval(TimeInterval(remainingTime))
  
  return SignalStatus(
    state: state,
    remainingTime: remainingTime,
    phase: Int(phase),
    cycle: Int(cycleDuration),
    endTime: endTime
  )
}

class TimeCalculator {
  let status = getSignalState(at: Date())
}
