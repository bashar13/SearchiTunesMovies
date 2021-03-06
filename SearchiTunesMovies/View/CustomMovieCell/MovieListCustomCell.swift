//
//  MovieListCustomCell.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 31/5/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

class MovieListCustomCell: UITableViewCell {
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var movieReleaseYear: UILabel!
    
    var movieViewModel: MovieViewModel! {
        didSet {
            movieName.text = movieViewModel.movieName
            movieReleaseYear.text = "\(MovieInfoConstants.releaseYear): \(movieViewModel.releaseYear)"
            movieImageView.kf.setImage(with: movieViewModel.imageURL, placeholder: movieViewModel.noPreviewImage)
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.backgroundColor = .gray

        // Configure the view for the selected state
    }
    
}
