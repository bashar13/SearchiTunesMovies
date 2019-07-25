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
    
    let name: String
    let year: String
    let imageURL: URL
    
    let noPreviewImage: UIImage
    
    init(movie: Movie) {
        self.name = movie.name
        self.year = movie.releaseYear
        self.imageURL = URL(string: movie.previewImageURL)!
        
        self.noPreviewImage = UIImage(named: TableViewConstants.noPreviewImage)!
    }
    
}
