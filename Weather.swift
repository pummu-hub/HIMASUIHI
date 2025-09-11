import SwiftUI
import Combine

// MARK: - 天気データモデル
struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let main: String
}

// MARK: - 天気取得マネージャー
class WeatherManager: ObservableObject {
    @Published var temperature: Double = 0
    @Published var condition: String = ""
    
    func fetchWeather(for city: String, completion: @escaping () -> Void = {}) {
        let apiKey = "7e8fe788bf136a32aa8eb7fb16433c13"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("天気取得失敗: \(error?.localizedDescription ?? "不明")")
                return
            }
            if let decoded = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    // 内部データとして保持
                    self.temperature = decoded.main.temp
                    self.condition = decoded.weather.first?.main ?? ""
                    completion() // 天気取得後に計算実行
                }
            }
        }.resume()
    }
}

// MARK: - 計算処理クラス
class Calculator {
    func calculate(baseValue: Double, weatherCondition: String) -> Double {
        switch weatherCondition {
        case "Clear":
            return baseValue * 1.2
        case "Rain":
            return baseValue * 0.8
        case "Snow":
            return baseValue * 0.5
        default:
            return baseValue
        }
    }
}

// MARK: - SwiftUIビュー（UIほぼなし）
struct ContentView: View {
    @StateObject var weatherManager = WeatherManager()
    let calculator = Calculator()
    
    // 計算用データ
    let city = "Tokyo"
    let baseValue = 100.0
    
    var body: some View {
        Text("") // 最小限のViewだけ必要
            .onAppear {
                weatherManager.fetchWeather(for: city) {
                    let result = calculator.calculate(baseValue: baseValue, weatherCondition: weatherManager.condition)
                    // コンソールに出力
                    print("都市: \(city)")
                    print("天気: \(weatherManager.condition)")
                    print("気温: \(weatherManager.temperature)℃")
                    print("計算結果: \(result)")
                }
            }
    }
}
