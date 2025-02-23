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
    case showSearchFilter(country: String = "us", catalogs: [String], keyword: String, showType: String = "movie")
    case showSearchTitle(title: String)
    case countries
    case country(countryCode: String)
    case genres
    case changes
    
    var path: String {
        switch self {
        case .show(imdbId: let imdbId):
            return "/shows/\(imdbId)"
        case .trendShows:
            return "/shows/top"
        case .showSearchFilter:
            return "/shows/search/filters"
        case .showSearchTitle:
            return "/shows/search/title"
        case .countries:
            return "/countries"
        case .country(countryCode: let countryCode):
            return "/countries/\(countryCode)"
        case .genres:
            return "/genres"
        case .changes:
            return "/changes"
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
                URLQueryItem(name: "country", value: "hk"),
                URLQueryItem(name: "service", value: "netflix")
            ]
        case .showSearchFilter(let country, let catelog, let keyword, let showType):
            return [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "catalogs", value: catelog.joined(separator: ",")),
                URLQueryItem(name: "keyword", value: keyword),
                URLQueryItem(name: "show_type", value: showType),
                URLQueryItem(name: "series_granularity", value: "show"),
                URLQueryItem(name: "order_direction", value: "asc"),
                URLQueryItem(name: "order_by", value: "original_title"),
                URLQueryItem(name: "genres_relation", value: "and"),
                URLQueryItem(name: "output_language", value: "en")
            ]
        case .showSearchTitle(title: let title):
            return [
                URLQueryItem(name: "title", value: title)
            ]
        case .countries:
            return [
                URLQueryItem(name: "output_language", value: "en")
            ]
        case .country:
            return [
                URLQueryItem(name: "output_language", value: "en")
            ]
        case .genres:
            return [
                URLQueryItem(name: "output_language", value: "en")
            ]
        case .changes:
            return [
                URLQueryItem(name: "change_type", value: "new"),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "item_type", value: "show"),
                URLQueryItem(name: "output_language", value: "en"),
                URLQueryItem(name: "order_direction", value: "asc"),
                URLQueryItem(name: "include_unknown_dates", value: "false"),
                URLQueryItem(name: "show_type", value: "movie")
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
    
    // MARK: API Request
    func fetchShow(imdbId: String) async throws -> Show {
        // 1. Create URL
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.show(imdbId: imdbId).path
        components?.queryItems = APIEndpoint.show(imdbId: imdbId).queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching show from URL: \(url)")
        
        // 2. Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // 3. Send Request
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON data: \(jsonString)")
            }
            
            // 4. Validate Response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // 5. Decode
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
        // 1. Create URL
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.trendShows.path
        components?.queryItems = APIEndpoint.trendShows.queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching trend shows from: \(url)")
        
        // 2. Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // 3. Send Request
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Trends shows: \(jsonString)")
            }
            
            // 4. Validate Response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // 5. Decode
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
    
    func fetchShowsBySearchFilter(country: String, catalogs: [String], keyword: String, showType: String) async throws -> [Show] {
        // 1. Create URL
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.showSearchFilter(country: country, catalogs: catalogs, keyword: keyword, showType: showType).path
        components?.queryItems = APIEndpoint.showSearchFilter(country: country, catalogs: catalogs, keyword: keyword, showType: showType).queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching Shows By Search Filter URL: \(url)")
        
        // 2. Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // 3. Send Request
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Shows Search Filter JSON: \(jsonString)")
            }
            
            // 4. Validate Response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // 5. Decode
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let showResponse: ShowResponse = try decoder.decode(ShowResponse.self, from: data)
                print("Successfully decoded shows - count \(showResponse.shows.count)")
                return showResponse.shows
            } catch let decodingError as DecodingError {
                throw APIError.decodeError(decodingError)
            }
        } catch let networkError as APIError {
            throw networkError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchShowsBySearchTitle(title: String) async throws -> [Show] {
        // 1. Create URL
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = APIEndpoint.showSearchTitle(title: title).path
        components?.queryItems = APIEndpoint.showSearchTitle(title: title).queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Fetching Shows By Search Title URL: \(url)")
        
        // 2. Create Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            // 3. Send Request
            let (data, response) = try await session.data(for: request as URLRequest)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Shows Search Title JSON: \(jsonString)")
            }
            
            // 4. Validate Response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            // 5. Decode
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
