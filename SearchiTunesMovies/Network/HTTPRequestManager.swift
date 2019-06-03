//
//  HTTPRequestManager.swift
//  SearchiTunesMovies
//
//  Created by Jahid Bashar on 3/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//func HTTPRequestCallToGetMovieData(url: String) {
//    var httpRequest = URLRequest(url: NSURL.init(string: url)! as URL)
//    httpRequest.httpMethod = "get"
//    httpRequest.timeoutInterval = 15
//    Alamofire.request(httpRequest).responseJSON { response in
//        if response.result.isSuccess {
//            print("Success")
//            let movieListJSON: JSON = JSON(response.result.value!)
//            print(movieListJSON)
//            //return movieListJSON
//        } else {
//            print("Error: \(String(describing: response.result.error))")
//            //return nil
//        }
//    }
//}



