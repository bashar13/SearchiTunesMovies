//
//  Movie.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 31/5/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import Foundation

class Movie {
    
    var name: String
    var releaseYear: String
    var director: String
    var genre: String
    var price: Float
    var currency: String
    var previewImageURL: String
    
    init(movieName: String, release: String, directorName: String, movieGenre: String, iTunesPrice: Float, priceCurrency: String,  imageURL: String) {
        name = movieName
        releaseYear = release
        director = directorName
        genre = movieGenre
        price = iTunesPrice
        currency = priceCurrency
        previewImageURL = imageURL
    }
}
