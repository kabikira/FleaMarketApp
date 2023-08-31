import Foundation
import PlaygroundSupport

// プレイグラウンドが非同期処理を完了するのを待つように設定
PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

struct FakeStoreModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct FakeStoreResponse: Codable {
    var items: [FakeStoreModel]?
}

let urlString = "https://fakestoreapi.com/products"
if let url = URL(string: urlString) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            print("No data:", error ?? "Unknown error")
            return
        }

        do {
            let decoder = JSONDecoder()
            let products = try decoder.decode([FakeStoreModel].self, from: data)
            for product in products {
                print("----------------------")
                print("Title: \(product.title)")
                print("Price: $\(product.price)")
                print("Category: \(product.category)")
                print("Description: \(product.description)")
                print("Image: \(product.image)")
            }
        } catch {
            print("Decoding error:", error)
        }

        // 非同期処理が終了したことを通知
        PlaygroundSupport.PlaygroundPage.current.finishExecution()
    }

    task.resume()
}

