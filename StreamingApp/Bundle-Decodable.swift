//
//  Bundle-Decodable.swift
//  StreamingApp
//
//  Created by Gary on 20/2/2025.
//

import Foundation

extension Bundle {
    func decode<T: Codable> (_ file: String) -> T {
        guard let url = url(forResource: file, withExtension: nil) else {
            fatalError( "File \(file) not found")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError( "Cannot read file \(file)")
        }
        
        let decode = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        decode.dateDecodingStrategy = .formatted(formatter)
        
        do {
            return try decode.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return fatalError( "Cannot decode file \(file)") as! T
        }
    }
}
