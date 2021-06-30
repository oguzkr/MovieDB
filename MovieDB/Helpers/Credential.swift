//
//  Credential.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import Foundation

struct Credential {
    static let BaseApi = "https://api.themoviedb.org/3/movie/popular?"
    static let ApiKey = "&api_key=fd2b04342048fa2d5f728561866ad52a"
    static var SelectedLang = Languages.turkish
    static let BasePic = "https://image.tmdb.org/t/p/w200"
}

struct Languages {
    static let turkish = "language=tr-TR"
    static let english = "language=en-US"
}
