//
//  Connecttivity.swift
//  SearchiTunesMovies
//  This class implements a variable to check the availability of internet connection
//  whenever the user need to access the internet
//
//  Created by Khairul Bashar on 3/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
