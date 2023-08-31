//
//  FakeStoreModel.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/08/30.
//

import Foundation

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


