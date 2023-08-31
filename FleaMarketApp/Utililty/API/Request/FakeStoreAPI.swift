//
//  FakeStoreAPI.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import Foundation
protocol FakeStoreRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension FakeStoreRequest {
    var baseURL: URL {
        return URL(string: "https://fakestoreapi.com")!
    }
    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        switch method {
        // 今回は.get以外のHTTPメソッドは考慮しない
        case .get:
            components?.queryItems = queryItems
        default:
            fatalError("Unsupprted method \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue

        // タイムアウトを60秒に設定
        urlRequest.timeoutInterval = 60

        return urlRequest
    }

    func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder()
        if (200..<300).contains(urlResponse.statusCode) {
            return try decoder.decode(Response.self, from: data)
        } else {
            throw try decoder.decode(FakeStoreAPIError.self, from: data)
        }
    }
}

final class FakeStoreAPI {
    // 全商品を取得
    struct GetProducts: FakeStoreRequest {
        typealias Response = [FakeStoreModel]

        var path: String {
            return "/products"
        }

        var method: HTTPMethod {
            return .get
        }

        var queryItems: [URLQueryItem] {
            return []
        }
    }
    // Electronicsカテゴリを取得
    struct GetElectronics: FakeStoreRequest {
        typealias Response = [FakeStoreModel]

        var path: String {
            return "/products/category/electronics"
        }

        var method: HTTPMethod {
            return .get
        }

        var queryItems: [URLQueryItem] {
            return []
        }
    }
    // jeweleryカテゴリを取得
    struct GetJewelerys: FakeStoreRequest {
        typealias Response = [FakeStoreModel]

        var path: String {
            return "/products/category/jewelery"
        }

        var method: HTTPMethod {
            return .get
        }

        var queryItems: [URLQueryItem] {
            return []
        }

    }
    struct GetMensClothings: FakeStoreRequest {
        typealias Response = [FakeStoreModel]

        var path: String {
            return "/products/category/men's clothing"
        }

        var method: HTTPMethod {
            return .get
        }

        var queryItems: [URLQueryItem] {
            return []
        }

    }
    struct GetWomensClothings: FakeStoreRequest {
        typealias Response = [FakeStoreModel]

        var path: String {
            return "/products/category/women's clothing"
        }

        var method: HTTPMethod {
            return .get
        }

        var queryItems: [URLQueryItem] {
            return []
        }

    }

}
