//
//  ViewController.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 31/5/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchBarVerticalPosition: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieListTableView: UITableView!
    var noResultLabel = UILabel()
    var movieArray: [Movie] = [Movie] ()
    
    let api = "https://itunes.apple.com"
    let endpoint = "/search?"
    
    //measure the total height of status bar + navigation bar
    var topDistance : CGFloat {
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            } else{
                let barHeight=self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        
        movieListTableView.register(UINib.init(nibName:"MovieListCustomCell", bundle: nil), forCellReuseIdentifier: "customMovieCell")
        
        //Initialize tap gesture to hide keyboard on tap outside the search field
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didViewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        configureTableView()
        movieListTableView.isHidden = true
       
    }

    //MARK - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieCell", for: indexPath) as! MovieListCustomCell
        
        cell.movieName.text = movieArray[indexPath.row].name
        cell.movieReleaseYear.text = movieArray[indexPath.row].releaseYear
        let url = URL(string: movieArray[indexPath.row].previewImageURL)
        let noPreviewImage = UIImage(named: "no-preview.png")
        cell.movieImageView.kf.setImage(with: url, placeholder: noPreviewImage)
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showMovieDetailPopUp(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func configureTableView(){
        movieListTableView.rowHeight = UITableView.automaticDimension
        movieListTableView.estimatedRowHeight = 600.0
        movieListTableView.keyboardDismissMode = .onDrag
    }
    
    //MARK - TableView related methods
    
    //hide keyboard on tap outside search bar
    @objc func didViewTapped() {
        searchBar.endEditing(true)
    }
    
    //shows movie detail on row selection
    func showMovieDetailPopUp(cellIndex: Int) {
        
        let alertTitle = movieArray[cellIndex].name
        let alertMessage = "Director: \(movieArray[cellIndex].director)\n" + "Genre: \(movieArray[cellIndex].genre)\n" + "Price: \(movieArray[cellIndex].price)"
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        createAlert(title: alertTitle, message: alertMessage, actionPositive: alertAction)
    }
    
    func updateUITableViewWithMovieData() {
        SVProgressHUD.dismiss()
        
        if movieArray.count == 0 {
            noResultLabel = UILabel(frame: CGRect(x: 0, y: searchBar.bounds.height + topDistance, width: view.frame.size.width/2, height: 60))
            view.addSubview(noResultLabel)
            noResultLabel.center.x = view.center.x
            noResultLabel.textColor = UIColor .white
            noResultLabel.font = UIFont.systemFont(ofSize: 14.0)
            noResultLabel.textAlignment = .center
            noResultLabel.lineBreakMode = .byWordWrapping
            noResultLabel.numberOfLines = 0;
            noResultLabel.text = "No movies found with title containing \(searchBar.text!)"
            
            movieListTableView.isHidden = true
        } else {
            movieListTableView.isHidden = false
            noResultLabel.isHidden = true
        }
        movieListTableView.reloadData()
        
    }
    
    //creates alert on call
    func createAlert(title: String, message: String, actionPositive: UIAlertAction, actionNegative: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(actionPositive)
        if let action = actionNegative {
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK - Search Bar delegate methods

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            if Connectivity.isConnectedToInternet {
                movieArray.removeAll(keepingCapacity: true)
                moveSearchBarToTop()
                let refinedSearchString = searchBar.text?.condenseWhitespace()
                
                let encodedSearchString = encodeInputSearchString(searchString: refinedSearchString!)
                buildURL(searchString: encodedSearchString)
                
            } else {
                let alertTitle = "No Internet Connection"
                let alertMessage = "Please connect to internet by WiFi or mobile data"
                let positiveAction = UIAlertAction(title: "Open Settings",
                                              style: UIAlertAction.Style.default,
                                              handler: openSettings)
                let negativeAction = UIAlertAction(title: "Cancel",
                                              style: UIAlertAction.Style.default,
                                              handler: nil)
                
                createAlert(title: alertTitle, message: alertMessage, actionPositive: positiveAction, actionNegative: negativeAction)
            }
            
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.becomeFirstResponder()
            }
            
        }
    }
    
    //MARK - Search Bar related methods
    
    func moveSearchBarToTop() {
        if searchBar.center.y == view.center.y {
            let adjustTopMargin = (view.bounds.height/2) - (topDistance + searchBar.bounds.height/2)
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: [],
                           animations: {
                            self.searchBarVerticalPosition.constant -= adjustTopMargin
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        SVProgressHUD.show()
        
    }
    
    func encodeInputSearchString(searchString: String)-> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.insert(charactersIn: " ")
        
        var encoded = searchString.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        
        return encoded!
    }
    
    func buildURL(searchString: String) {
        let locale = Locale.current
        
        let keyMedia: String! = "media"
        let valueMedia: String! = "movie"
        let keyEntity: String! = "entity"
        let valueEntity: String! = "movie"
        let keyAttr: String! = "attribute"
        let valueAttr: String! = "movieTerm"
        let keyLimit: String! = "limit"
        let valueLimit: String! = "20"
        let keyLang: String! = "lang"
        let valueLang: String! = "en_us"
        print(searchString)
        let queryCriteria = [URLQueryItem(name: "term", value: searchString), URLQueryItem(name: "country", value: locale.regionCode), URLQueryItem(name: keyMedia!, value: valueMedia), URLQueryItem(name: keyEntity!, value: valueEntity), URLQueryItem(name: keyAttr!, value: valueAttr), URLQueryItem(name: keyLimit!, value: valueLimit), URLQueryItem(name: keyLang, value: valueLang )]
        
        let baseURLComps = NSURLComponents(string: api + endpoint)
        baseURLComps?.queryItems = queryCriteria
        let finalURL = baseURLComps?.string
        
        HTTPRequestCallToGetMovieData(url: finalURL!)
        searchBar.endEditing(true)
    }
    
    func openSettings(alert: UIAlertAction!) {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: Networking call
    
    func HTTPRequestCallToGetMovieData(url: String) {
        var httpRequest = URLRequest(url: NSURL.init(string: url)! as URL)
        httpRequest.httpMethod = "get"
        httpRequest.timeoutInterval = 15
        Alamofire.request(httpRequest).responseJSON { response in
            if response.result.isSuccess {
                print("Success")
                let movieListJSON: JSON = JSON(response.result.value!)
                print(movieListJSON)
                self.updateMovieData(json: movieListJSON)
            } else {
                print("Error: \(String(describing: response.result.error))")
                //return nil
            }
        }
    }
    
    
    
    
    func updateMovieData(json: JSON) {
        
        if let searchCount = json["resultCount"].int {
            print(searchCount)
            for movieItem in 0..<searchCount {
                let movie = Movie(movieName: json["results"][movieItem]["trackName"].stringValue, release: json["results"][movieItem]["releaseDate"].stringValue, directorName: json["results"][movieItem]["artistName"].stringValue, movieGenre: json["results"][movieItem]["primaryGenreName"].stringValue, iTunesPrice: json["results"][movieItem]["trackPrice"].floatValue, imageURL: json["results"][movieItem]["artworkUrl100"].stringValue)
                movieArray.append(movie)
            }
            updateUITableViewWithMovieData()
        } else {
            
        }
            
    }
    
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

