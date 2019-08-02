//
//  MovieResult.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 2019-08-01.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import Foundation

struct MovieResult: Codable {
    
    let resultCount: Int
    let results: [Movie]
}
