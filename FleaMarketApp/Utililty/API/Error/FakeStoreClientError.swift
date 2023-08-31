//
//  FakeStoreClientError.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import Foundation

enum FakeStoreClientError: Error {
    case connectionError(Error)

    case responseParseError(Error)

    case apiError(FakeStoreAPIError)
}
