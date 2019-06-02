//
//  MovieListCustomCell.swift
//  SearchiTunesMovies
//
//  Created by Jahid Bashar on 31/5/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit

class MovieListCustomCell: UITableViewCell {
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var movieReleaseYear: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
