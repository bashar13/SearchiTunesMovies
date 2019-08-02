//
//  Encoder.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 3/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

class Encoder {
    
    /**
     Encodes the input string in search bar, mainly removes all spaces with "+" sign as per iTunes api requirement
     - Parameters: searchString: input text in search field
     - Returns: an encoded String
     - Precondition: input string should be regular string with no multiple whispaces
     */
    static func encodeInputSearchString(searchString: String)-> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.insert(charactersIn: " ")
        
        var encoded = searchString.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        
        return encoded!
    }
    
    /**
     Builds the final URL to make the HTTP request
     - Parameters: searchString: encoded input text of the search bar, String type
     - Returns: a String containing the full URL to request
     */
    static func buildURL(searchString: String)-> String? {
        let locale = Locale.current
        print(searchString)
        let queryCriteria = [URLQueryItem(name: ITunesQueryKeyConstants.keyTerm, value: searchString),
                             URLQueryItem(name: ITunesQueryKeyConstants.keyCountry, value: locale.regionCode),
                             URLQueryItem(name: ITunesQueryKeyConstants.keyMedia!, value: ITunesQueryValueConstants.valueMovie),
                             URLQueryItem(name: ITunesQueryKeyConstants.keyEntity!, value: ITunesQueryValueConstants.valueMovie),
                             URLQueryItem(name: ITunesQueryKeyConstants.keyAttr!, value: ITunesQueryValueConstants.valueMovieTerm),
                             URLQueryItem(name: ITunesQueryKeyConstants.keyLimit!, value: ITunesQueryValueConstants.valueLimit)]
        
        let baseURLComps = NSURLComponents(string: URLConstants.api + URLConstants.endpointSearch)
        baseURLComps?.queryItems = queryCriteria
        let finalURL = baseURLComps?.string
        
        return finalURL
    }
    
    /**
     Fetches the SubString year from the date input
     - Parameters: a String that contains the time and date
     - Returns: a String that contains the date only
     - Precondition: The time and date must be in format "2017-12-05T08:00:00Z"
     */
    static func getYearFromReleaseDate(date: String)-> String{
        let startIndex = date.index(date.startIndex, offsetBy: 0)
        let endIndex = date.index(date.endIndex, offsetBy: -16)
        let yearIndex = String(date[startIndex..<endIndex])
        
        return yearIndex
    }
    
}

// MARK: Extended String class

/**
 An extension of the String class by implementing a function to remove any extra whitespaces in the given input search string.
 - Returns: a refined String with no extra whitespaces
 */
extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
