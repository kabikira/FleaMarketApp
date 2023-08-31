//
//  FakeStoreClient.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import Foundation

protocol HTTPClient {
    func sendRequest( _ urlRequest: URLRequest, completion: @escaping(Result<(Data, HTTPURLResponse), Error>) -> Void)
}

extension URLSession: HTTPClient {
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let task = dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data, let urlResponse = urlResponse as? HTTPURLResponse else {
                fatalError("invalid response combination \(String(describing: (data, urlRequest, error))).")
            }
            completion(.success((data, urlResponse)))
        }
        task.resume()
    }
}
final class FakeStoreClient {
    private let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func send<Request: FakeStoreRequest>(
        request: Request,
        completion: @escaping (Result<Request.Response, FakeStoreClientError>) -> Void)
    {
        let urlRequest = request.buildURLRequest()
        httpClient.sendRequest(urlRequest) { result in
            switch result {
            case .success((let data , let urlResponse)):
                do {
                    let response = try request.response(from: data, urlResponse: urlResponse)
                    completion(.success(response))
                } catch {
                    completion(.failure(.responseParseError(error)))
                }
            case .failure(let error):
                completion(.failure(.connectionError(error)))
            }
        }
    }
}
