//
//  ViewController.swift
//  SignalApp
//
//  Created by れおう on 2025/09/04.
//

import UIKit

//画面の表示設定
class ViewController: UIViewController {
    
    let signalLabel = UILabel()
    let countdownLabel = UILabel()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        [signalLabel, countdownLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            view.addSubview(label)
            
        }
        
        NSLayoutConstraint.activate([
            signalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signalLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
        ])
    }
    
    func startTimer() {
        updateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateLabels()
        }
    }
    
    func updateLabels() {
        let timeCalc = TimeCalculator()
        if timeCalc.current_signal == "赤信号" {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .green
        }
        signalLabel.text = "現在は:\(timeCalc.current_signal)"
        countdownLabel.text = "次の切り替えまで:\(timeCalc.secondsUntilChange)秒"
    }
}
