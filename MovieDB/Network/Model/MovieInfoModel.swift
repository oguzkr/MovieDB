//
//  MovieInfoModel.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import Foundation

// MARK: - MovieInfoModel
struct MovieInfoModel:Codable {
    let page: Int
    let results: [Result]
    let total_pages, total_results: Int
}

// MARK: - Result
struct Result:Codable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language, original_title, overview: String
    let popularity: Double
    let poster_path: String
    let release_date: String?
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}
