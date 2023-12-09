//
//  Modal.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import Foundation

// MARK: - ProductResponseElement
struct ProductResponseElement: Codable {
    let image: String
    let price: Double
    let productName, productType: String
    let tax: Double

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

typealias ProductResponse = [ProductResponseElement]

// MARK: - AddProductResponse
struct AddProductResponse: Codable {
    let message: String
    let productDetails: ProductDetails
    let productID: Int
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productID = "product_id"
        case success
    }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let image: String
    let price: Int
    let productName, productType: String
    let tax: Int

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
