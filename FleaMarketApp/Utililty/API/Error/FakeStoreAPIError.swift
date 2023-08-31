//
//  FakeStoreAPIError.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import Foundation

struct FakeStoreAPIError: Decodable, Error {
    var statusCode: Int
    var error: String
    var message: String
}
