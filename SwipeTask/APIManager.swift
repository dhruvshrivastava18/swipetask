//
//  APIManager.swift
//  SwipeTask
//
//  Created by Dhruv Shrivastava on 07/12/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://app.getswipe.in/api/public/"
    
    
    func makeRequest<T: Codable>(endpoint: String, method: HTTPMethod, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print(method.rawValue)
        request.httpBody = body
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "HTTP Error", code: 0, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    func makePostRequest<T: Codable>(endpoint: String, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        makeRequest(endpoint: endpoint, method: .post, body: body, completion: completion)
    }
}
