//
//  TimeCalculator.swift
//  SignalApp
//
//  Created by れおう on 2025/09/04.
//
import Foundation
//時間計算
class TimeCalculator {
    let red_time = 90 //赤信号の時間（秒）
    let blue_time = 30 //青信号の時間（秒）
    
    var one_set: Int{ //1周あたりの時間
        red_time + blue_time
    }
    
    //現在の時、分、秒を取得
    var hour = Calendar.current.component(.hour, from: Date())
    var minute = Calendar.current.component(.minute, from: Date())
    var second = Calendar.current.component(.second, from: Date())
    
    var now: Int{ //取得した時間をもとに、今が何色にあたるか計算
        (hour * 3600 + minute * 60 + second) % one_set
    }
    
    var current_signal: String {
        if now < red_time {
            return "赤信号"
        } else {
            return "青信号"
        }
    }
    
    //残り時間の計算
    var secondsUntilChange: Int {
        if now < red_time {
            return red_time - now
        } else {
            return one_set - now
        }
    }

}
