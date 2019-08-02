//
//  Movie.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 31/5/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let trackName: String
    let releaseDate: String
    let artistName: String
    let primaryGenreName: String
    let trackPrice: Float
    let currency: String
    let artworkUrl100: String
    
}
