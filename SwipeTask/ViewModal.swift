//
//  ViewModal.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import Foundation
import UIKit
class ViewModel: ObservableObject {
    @Published var response: ProductResponse?
    @Published var error: Error?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    static let shared = ViewModel()
    @Published var array: [ProductResponseElement] = []
    @Published var filteredArray: [ProductResponseElement] = []
    func createProduct(productName: String, productType: String, price: String, tax: String, imageData: Data) {
        isLoading = true
        let parameters = [
            "product_name" : productName,
            "product_type" : productType,
             "price" : price,
            "tax" : tax
        ] as [String : Any]
        
        uploadImageToServer(imageData: imageData, parameters: parameters, serverURL: URL(string: "https://app.getswipe.in/api/public/add")!)
    }
    func getProduct() {
        
        isLoading = true
        
        do {
            
            APIManager.shared.makeRequest(endpoint: "get", method: .get) { (result: Result<ProductResponse, Error>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.array = response
                        self.filteredArray = self.array
                        self.isLoading = false
                        print(response)
                       
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error
                        self.isLoading = false
                        print(error)
                      
                    }
                }
            }
        }
    }
    func uploadImageToServer(imageData: Data, parameters: [String: Any], serverURL: URL) {
        
        
        // Create a URLRequest with the server URL
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        
        // Set the content type for the request
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        // Create a boundary string for multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Set the Content-Type header with the boundary
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create the body of the request
        var body = Data()
        
        // Append JSON parameters to the body
        for (key, value) in parameters {
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8)
            body.append(contentsOf: "\(value)\r\n".utf8)
        }
        
        // Append image data to the body
        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".utf8)
        body.append(contentsOf: "Content-Type: image/jpeg\r\n\r\n".utf8)
        body.append(imageData)
        body.append(contentsOf: "\r\n".utf8)
        
        // Close the body with the boundary
        body.append(contentsOf: "--\(boundary)--\r\n".utf8)
        
        // Set the request body
        request.httpBody = body
        
        // Create a URLSession task for the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the response or error here
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error)")
                    self.isLoading = false
                    self.showAlert = true
                    self.alertMessage = "Error creating Pass: \(error.localizedDescription)"
                }
            } else if let data = data {
                // Parse the response data if needed
                DispatchQueue.main.async {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                    self.isLoading = false
                    self.showAlert = true
                    self.alertMessage = "Product successfully added!"
                }
            }
        }
        
        // Start the task
        task.resume()
    }
    
    func search(query: String) {
        filteredArray = query.isEmpty ? array : array.filter { $0.productName.contains(query)}
    }
}
