//
//  Show.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import Foundation

struct ShowResponse: Codable {
    let shows: [Show]
}

struct Show: Codable, Identifiable {
    let id: String
    let imdbId: String
    let tmdbId: String
    let title: String
    let overview: String
    let releaseYear: Int?
    let firstAirYear: Int?
    let lastAirYear: Int?
    let originalTitle: String
    let genres: [Genre]
    let creators: [String]?
    let cast: [String]
    let rating: Int
    let seasonCount: Int?
    let episodeCount: Int?
    let imageSet: ImageSet
}

struct Genre: Codable {
    let id: String
    let name: String
}

struct ImageSet: Codable {
    let verticalPoster: PosterSet
    let horizontalPoster: PosterSet
//    let verticalBackdrop: BackdropSet
//    let horizontalBackdrop: BackdropSet
    
}

struct PosterSet: Codable {
    let w240: String?
    let w360: String?
    let w480: String?
    let w600: String?
    let w720: String?
    let w1080: String?
    let w1440: String?
}

protocol ImageSizeProvider {
    func getImageURL(for width: Int) -> String?
}

extension PosterSet: ImageSizeProvider {
    static let mock: PosterSet = .init(
        w240: "https://cdn.movieofthenight.com/show/12/poster/vertical/en/240.jpg?Expires=1769131009&Signature=kxFQQuSiy1W-OmnCI429~xZTFYCimCDt-Dy8ynGgeTjb~HTMlOAy4G7l2DWeJLm7Pc2qOl5P3mQs7vN0rdFl1t-d6RDDISNG~lPpFVCpSXEW4OYL2uJ3Tvpb80I8eDIc4-~Y61PJuwD1Qhvvol6bZgcXThXXgtf8NV4D6lf4TDvV9d3rT~rd7ah1dKvg2TmTDACqrXaVBfktKPO1NXr-qLbh2Yyf3n1P6HJedPE3Pqp-j5KujX3xsehtXzO1Q51K0~Y3g1T4vREUsUzU8sZiKMjWchSwugYVX1~JOP0bipNTbdo6mqZ9vIJrSrUJvJEhIe1FJZpgR25Vrf6sY3DLgw__&Key-Pair-Id=KK4HN3OO4AT5R",
        w360: "https://cdn.movieofthenight.com/show/12/poster/vertical/en/360.jpg?Expires=1769131009&Signature=AehW75yBFJ8UoH1DPkCJWwDksLExQcgYer11R1RxoVH-0FYGWpVsjG54fNoqcl0LVnp~z3QoBicsSAqaM7N~PACI6eesNi20KJsaCocePcINZ8Gljslmu8WG~DQm8I-zkhdfqxlbqatu2k-I6e9lMFvoFxGHANXH9M43OxK1J7O5CG7JOjstmrv5ACHOk546emBSh-wk4Yg6QB5J8zT82rxqSqwnZj09t06aecNZ6cxKkZqaXmILdE8sqwHdhl0khr5UAccN7ALzjDD3JDnnFi~-hiHYGX1kiwEzhlM4u4zivd3aYGX~5NHU-AWOtytyCYO4IrPIG4ZlHUL0AMYaeQ__&Key-Pair-Id=KK4HN3OO4AT5R",
        w480: "https://cdn.movieofthenight.com/show/12/poster/vertical/en/480.jpg?Expires=1769131009&Signature=HMbtdxFMLjkF~Cde4jVzTYtla9-jIqBAzAcVDR1Q1~jVTJa1CkO8mvrejIi1aE3jmuTqodzXHSsT96a66sGc5LI4Yov-raeUCI-3HUe6B4Wg4V6YdSVT3VI2MWeVGW7A1bHoWHPRePeVwjn5LGveXW67wrnfR~h0Xwf3v~E4NLg3R28HVrKhnLi7DA~Pti2BZ6VrlhPQGYDzIa-79mgremACdO4JTrgRe2maYwzWSas7BzRqBzFFcfrqjVlxIU9MONosIk3zE7fnewxO~PPksua3kHcBiHhf7-ZHZsDO~y7XkEDBvJE8utf0oPNA7KzaFLDkEU72HYhuN64toH-3yQ__&Key-Pair-Id=KK4HN3OO4AT5R",
        w600: "https://cdn.movieofthenight.com/show/12/poster/vertical/en/600.jpg?Expires=1769131009&Signature=fm~Vk7mswmkFjyz0TCT-VDI~pQTsW-8TulIfthnnLZpkOzQxJyg9c0h-9-t4LkZ~vMEUTD7NqLnJDlraJ-MzUxbc3NXjH6AIp4rN1wi9yMrab9oaL714N7sQerWhA08e0Dt4KLxCxq-oMisgZissi7Q5Yb-saU9~gksytBG4~O5o6~5HIO~cPegk~ZIVpJx5UuVjW5hCZT8bXtOY4oujbw5hR3ANuCRjAMpWc8SO8MHUTcBE7vvAuXl2di-k8GLkAhrJ0HpwoIYh7-Y5pTQ2O5uxuTDB0FYE-5CZa4hdGt88Vh30D-LCTL9ZKdOKkrEzTf3MCYAXOB7pM7W3Gkd7DA__&Key-Pair-Id=KK4HN3OO4AT5R",
        w720: "https://cdn.movieofthenight.com/show/12/poster/vertical/en/720.jpg?Expires=1769131009&Signature=J4rfUHXZYeinuT6h00DWpv-ac~geOCSVtegc2c78OdhOz3sWaqKLpY3GzjO6CyaE9WZvxtV1tHmGi9HzGks49bkx-QttpuwIvTmqS9OBaEcJ4bBa2wSS~pZEcoxC0kItbyY8RGrpBqAE0cN4tJ617iCPMlB3teXY7ir82bGWx-jwiIMQGtzvPcl2NyQsRIfAMa16rGNwUA0Up~fpRLoVmLPJoybenkv-S81m7rSxxXnzkzK-uHf1gzP38LMW~qnSllgEg7x11~liFHWJa3MLjPBr-yuaGeghwFbQsF0FvVq5eDOLD-qVT7VBOa3uGsIlVuIGvsM1ECj5pRu3ytFBtA__&Key-Pair-Id=KK4HN3OO4AT5R",
        w1080: "https://cdn.movieofthenight.com/show/12/poster/horizontal/en/1080.jpg?Expires=1769131015&Signature=MQlUUxVEqbf2MjZ4py6yDsjOH7lEqNntQrXHkbvM3v-rzNLWtSXSHAbRLjOYS5hn46uVBEqMHBw7RyYic8hqezsbdFIfQXYb67IgZH6qTdKcYLi91ixPQ~cNxwuKtxnPijd0F6Md0nuHNhigrJZp2H9CkcSDl1TSucXpZX9zj77Vy8gDVU4b2~20Tt-L7d1kOHA6KFbfRzMGihwMVs-90pFX8pKMkTt~aEVlaQCxUJYjJW9uCWss~DiRqeI1JacTRlduhlgC8e~Gz4OWROTWTjpQMVVvI9VXSrLtdjWnG28BiRlhapMR0HlED7319viJ4qgMffjOa2Uns3SzZm4c1A__&Key-Pair-Id=KK4HN3OO4AT5R",
        w1440: "https://cdn.movieofthenight.com/show/12/poster/horizontal/en/1440.jpg?Expires=1769131015&Signature=csVtAKJJnEGA2pXljOm-n2R1l-FgIgO9Gnmq0oeYrf06XRyfDJPIqDbJyoOwTPOGu7RHIfmAZRneQYVyCAmDWs5jNcWMbuMzArcXWI-Li2zxsaZ3Phq6t1XcALHNWaHoyaFcJRQRGWR6ey~cbaF~qNkJUQsaBNeNbfwm6aUpIldHgrhQEcF-cTS6xI-AFnCWoTrIJZUmg0yRPT-bq6riCAmaJxCvKaA4lznYRW7Oj8yxlKKJYn2vNXWT6J0KXs3PmHmoleLfIsDo6YgHCUxAyPFRV3hMISvjStq~trfBkAoNtgn0fP3nep2xFgC~f9NU2HL5MOGlt18tT5S2LNA9Ug__&Key-Pair-Id=KK4HN3OO4AT5R"
    )
    
    func getImageURL(for width: Int) -> String? {
        switch width {
        case ...240: return w240
        case ...360: return w360
        case ...480: return w480
        case ...600: return w600
        case ...720: return w720
        case ...1080: return w1080
        default: return w1440
        }
    }
}

extension Show {
    private static func generateRandomId() -> String {
        return UUID().uuidString.prefix(8).lowercased()
    }
    static let mock: Show = .init(
        id: generateRandomId(),
        imdbId: "tt7366338",
        tmdbId: "tv/87108",
        title: "Chernobyl",
        overview: "Starring Jared Harris, Stellan Skarsgard and Emily Watson, 'Chernobyl' tells the story of the 1986 nuclear accident in this HBO Miniseries.",
        releaseYear: 2019,
        firstAirYear: 2019,
        lastAirYear: 2020,
        originalTitle: "Chernobyl",
        genres: [
            Genre(id: "drama", name: "Drama"),
            Genre(id: "history", name: "History"),
            Genre(id: "thriller", name: "Thriller")
        ],
        creators: ["Craig Mazin", "Kyle Kuzma"],
        cast: ["Jared Harris", "Stellan Skarsgård", "Emily Watson"],
        rating: 90,
        seasonCount: 1,
        episodeCount: 5,
        imageSet: ImageSet(verticalPoster: PosterSet.mock, horizontalPoster: PosterSet.mock)
    )
    
    static let mockShowFromJsonFile: Show = Bundle.main.decode("show.json")
    
    static var mockShowsFromJsonFile: [Show] {
        let response: ShowResponse = Bundle.main.decode("shows.json")
        return response.shows
    }
        
}
