//
//  Constants.swift
//  SearchiTunesMovies
//
//  Created by Jahid Bashar on 3/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit

struct URLConstants {
    static let api: String = "https://itunes.apple.com"
    static let endpointSearch: String = "/search?"
    static let timeOutRequest: Double = 15.0
}

struct TableViewConstants {
    static let estimatedRowHeight: CGFloat = 200.0
    static let noPreviewImage: String = "no-preview.png"
}

struct MovieInfoConstants {
    static let title: String = "Title"
    static let releaseYear: String = "Release Year"
    static let director: String = "Director"
    static let genre: String = "Genre"
    static let price: String = "Price"
}

struct AlertActionConstants {
    static let buttonOk: String = "OK"
    static let buttonCancel: String = "Cancel"
    static let buttonOpenSettings: String = "Open Settings"
}

struct Constants {
    static let noResult: String = "No result with title containing "
    static let systemError: String = "System error: Unable to search, please try again later"
    static let noInternet: String = "No Internet Connection"
    static let connectInternet: String = "Please connect to internet by WiFi or mobile data"
    static let ITunesServerError: String = "Server error: Unable to receive data from iTunes, please try again later"
}

struct ITunesQueryKeyConstants {
    static let keyTerm: String = "term"
    static let keyCountry: String = "country"
    static let keyMedia: String! = "media"
    static let keyEntity: String! = "entity"
    static let keyAttr: String! = "attribute"
    static let keyLimit: String! = "limit"
}

struct ITunesQueryValueConstants {
    static let valueMovie: String! = "movie"
    static let valueMovieTerm: String! = "movieTerm"
    static let valueLimit: String! = "20"
}

struct UIViewMarginConstant {
    static let leadingMargin: CGFloat = 10
    static let trailingMaring: CGFloat = 10
    static let topMargin: CGFloat = 10
    static let bottomMargin: CGFloat = 10
}

