//
//  ApiClient.swift
//  StreamingApp
//
//  Created by Gary on 20/2/2025.
//

import Foundation

struct ApiClient {
    enum APIError: Error {
        case invalidResponse
        case decodeError(DecodingError)
        case networkError(Error)
        
        var localizedDescription: String {
            switch self {
            case .invalidResponse:
                return "Invalid response format"
            case .decodeError(let error):
                return "Decoding error: \(error.localizedDescription)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchShow() async throws -> Show {
        let headers = [
            "x-rapidapi-key": "8d90e19104msh470d211a8eb2ce1p125799jsn9989d06cb713",
            "x-rapidapi-host": "streaming-availability.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://streaming-availability.p.rapidapi.com/shows/tt0120338?series_granularity=episode&output_language=en")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        do {
            // 3. 發送請求
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON data: \(jsonString)")
            }
            
            // 4. 驗證響應
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // 5. 解碼數據
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let show = try decoder.decode(Show.self, from: data)
                print("Successfully decoded show - \(show.title)" )
                return show
            } catch let decodingError as DecodingError {
                throw APIError.decodeError(decodingError)
            }
        } catch let networkError as APIError {
            throw networkError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchTrendShows() async throws -> [Show] {
        return []
    }
}
