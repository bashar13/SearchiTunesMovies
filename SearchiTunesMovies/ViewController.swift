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

enum SearchKeys: String {
    case KEY_MEDIA = "media"
    case KEY_ENTITY = "entity"
    
}

enum SearchValues: String {
    case VALUE_MEDIA, VALUE_ENTITY = "movie"

}

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    

    @IBOutlet weak var searchBarVerticalPosition: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var movieListTableView: UITableView!
    var movieArray: [Movie] = [Movie] ()
    let baseURL = "https://itunes.apple.com/search?"
    var noResultLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        
        movieListTableView.register(UINib.init(nibName:"MovieListCustomCell", bundle: nil), forCellReuseIdentifier: "customMovieCell")
        
        //movieListTableView.separatorStyle = .none
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(didViewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureTableView()
        movieListTableView.isHidden = true
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieCell", for: indexPath) as! MovieListCustomCell
        
        cell.movieName.text = movieArray[indexPath.row].name
        cell.movieReleaseYear.text = movieArray[indexPath.row].releaseYear
        let url = URL(string: movieArray[indexPath.row].previewImageURL)
        cell.movieImageView.kf.setImage(with: url, placeholder: nil)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! MovieListCustomCell
//        cell.contentView.backgroundColor = .black
        showMovieDetailPopUp(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        searchBar.endEditing(true)
//    }
    
    func configureTableView(){
        movieListTableView.rowHeight = UITableView.automaticDimension
        movieListTableView.estimatedRowHeight = 600.0
        movieListTableView.keyboardDismissMode = .onDrag
    }
    
    @objc func didViewTapped() {
        searchBar.endEditing(true)
    }
    
    func showMovieDetailPopUp(cellIndex: Int) {
        
        let title = movieArray[cellIndex].name
        let message = "Director: \(movieArray[cellIndex].director)\n" + "Genre: \(movieArray[cellIndex].genre)\n" + "Price: \(movieArray[cellIndex].price)"
        
        let alertPopUp = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) {(action) in
            alertPopUp.dismiss(animated: true, completion: nil)
        }
        alertPopUp.addAction(alertAction)
        present(alertPopUp, animated: true, completion: nil)
        
    }
    
    

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            movieArray.removeAll(keepingCapacity: true)
            moveSearchBarToTop()
            let refinedSearchString = searchBar.text?.condenseWhitespace()
            
            let encodedSearchString = encodeInputSearchString(searchString: refinedSearchString!)
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
            print(encodedSearchString)
            let queryCriteria = [URLQueryItem(name: "term", value: encodedSearchString), URLQueryItem(name: "country", value: locale.regionCode), URLQueryItem(name: keyMedia!, value: valueMedia), URLQueryItem(name: keyEntity!, value: valueEntity), URLQueryItem(name: keyAttr!, value: valueAttr), URLQueryItem(name: keyLimit!, value: valueLimit), URLQueryItem(name: keyLang, value: valueLang )]
            
            let urlComps = NSURLComponents(string: baseURL)
            urlComps?.queryItems = queryCriteria
            let finalURL = urlComps?.string
            
            let urlString = "https://itunes.apple.com/search?term=American&country=US&media=movie&entity=movie&attribute=movieTerm&limit=20&lang=en_us" //"\(String(describing: finalURL))"
            
            print(urlString)
            
            getListOfMovies(url: finalURL!)
            searchBar.endEditing(true)
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.becomeFirstResponder()
            }
            
        }
    }
    
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
    
    //MARK: Networking call
    
    func getListOfMovies(url: String) {
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
            }
        }
        
    }
    
    func encodeInputSearchString(searchString: String)-> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.insert(charactersIn: " ")

        var encoded = searchString.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        
        return encoded!
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
    
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

