//
//  MovieViewModel.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 2019-07-24.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    
    let movieName: String
    let releaseYear: String
    let director: String
    let genre: String
    let price: Float
    let currency: String
    let imageURL: URL
    
    let noPreviewImage: UIImage
    
    init(movie: Movie) {
        movieName = movie.trackName
        releaseYear = Encoder.getYearFromReleaseDate(date: movie.releaseDate)
        director = movie.artistName
        genre = movie.primaryGenreName
        price = movie.trackPrice
        currency = movie.currency
        imageURL = URL(string: movie.artworkUrl100)!
        
        self.noPreviewImage = UIImage(named: TableViewConstants.noPreviewImage)!
    }
    
}
