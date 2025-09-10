//
//  ContentView.swift
//  WatareruMon
//　メインUIコード
//  Created by 槇原 陸斗 on 2025/09/07.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionValue: String? = nil
    @State private var secondsUntilChangeDisplay: Int = 0
    @State private var signalColorDisplay: String = ""
    // 信号・残り時間表示更新用の毎秒呼び出しタイマー
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            //全体背景の色設定
            Color(.secondarySystemBackground)
            
            //ここからUIの設置
            VStack {
                ZStack {
                    //信号機を模した図形の背景
                    //ここのカラーを信号が青の時は緑、赤の時は赤色にする
                    RoundedRectangle(cornerRadius: 20)
                        .fill(signalColorDisplay == "赤信号" ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
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
                        Text("次\(signalColorDisplay)になるまで：\(secondsUntilChangeDisplay)秒")
                            .font(.system(size: 25)).onReceive(timer) { _ in
                                signalColorDisplay = TimeCalculator().current_signal
                                secondsUntilChangeDisplay = TimeCalculator().secondsUntilChange
                            }
                        
                        //このTextを変えればいいと思います（歩きで間に合います, 早歩きを推奨しますetc...）
                        Text("早歩きを推奨します")
                            .font(.system(size: 30))
                        
                        //文字の位置調整用のframe
                        Color(.secondarySystemBackground).frame(width: 400, height: 28)
                    }
                    
                }
            }
        }
        
    
    }
}

#Preview {
    ContentView()
}
