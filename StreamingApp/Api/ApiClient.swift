//
//  ApiClient.swift
//  StreamingApp
//
//  Created by Gary on 20/2/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodeError(DecodingError)
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response format"
        case .decodeError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

enum APIEndpoint {
    case show(imdbId: String)
    case trendShows
    
    var path: String {
        switch self {
        case .show(imdbId: let imdbId):
            return "/shows/\(imdbId)"
        case .trendShows:
            return "/shows/top"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .show:
            return [
                URLQueryItem(name: "series_granularity", value: "episode"),
                URLQueryItem(name: "output_language", value: "en")
            ]
        case .trendShows:
            return [
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "service", value: "netflix")
            ]
        }
    }
}

struct ApiClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    let headers = [
        "x-rapidapi-key": APIConfig.apiKey,
        "x-rapidapi-host": APIConfig.apiHost
    ]
    
    func fetchShow(imdbId: String) async throws -> Show {
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.show(imdbId: imdbId).path
        components?.queryItems = APIEndpoint.show(imdbId: imdbId).queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching show from URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // Request
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
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.trendShows.path
        components?.queryItems = APIEndpoint.trendShows.queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching trend shows from: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // 3. 發送請求
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Trends shows: \(jsonString)")
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
                let shows = try decoder.decode([Show].self, from: data)
                print("Successfully decoded shows - count \(shows.count)")
                return shows
            } catch let decodingError as DecodingError {
                throw APIError.decodeError(decodingError)
            }
        } catch let networkError as APIError {
            throw networkError
        } catch {
            throw APIError.networkError(error)
        }
    }
}
