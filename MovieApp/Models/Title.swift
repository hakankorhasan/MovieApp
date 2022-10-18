//
//  Movie.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 23.09.2022.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let popularity: Double
}
