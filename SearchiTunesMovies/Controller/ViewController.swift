//
//  ViewController.swift
//  SearchiTunesMovies
//
//  Created by Khairul Bashar on 31/5/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchBarVerticalPosition: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieListTableView: UITableView!
    var noResultLabel: UILabel?
    var movieResult: MovieResult?
    var movieViewModelArray: [MovieViewModel] = [MovieViewModel]()
    
    //measure the total height of status bar + navigation bar
    var topDistance : CGFloat {
        get{
            if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                return 0
            } else{
                let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        configureTableView()
        
        //hide the tableview initially as the list is empty
        movieListTableView.isHidden = true
    }

    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieCell", for: indexPath) as! MovieListCustomCell
        let movieViewModel = movieViewModelArray[indexPath.row]
        cell.movieViewModel = movieViewModel
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showMovieDetailPopUp(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: TableView related other methods
    
    //hide keyboard on tap outside search bar
    @objc func didViewTapped() {
        searchBar.endEditing(true)
    }
    
    //Initial configuration of the table view
    func configureTableView(){
        movieListTableView.rowHeight = UITableView.automaticDimension
        movieListTableView.estimatedRowHeight = TableViewConstants.estimatedRowHeight
        movieListTableView.keyboardDismissMode = .onDrag
    }
    
    
    /**
     Shows movie detail on row selection by calling showAlert method
     - Parameters: cellIndex: selected row number in the table view, an Int value
     - Returns: None
     */
    func showMovieDetailPopUp(cellIndex: Int) {
        
        let alertTitle = movieViewModelArray[cellIndex].movieName
        let alertMessage =
            "\(MovieInfoConstants.director): \(movieViewModelArray[cellIndex].director)\n"
            + "\(MovieInfoConstants.genre): \(movieViewModelArray[cellIndex].genre)\n"
            + "\(MovieInfoConstants.price): \(movieViewModelArray[cellIndex].currency) \(movieViewModelArray[cellIndex].price)"
        
        let alertAction = UIAlertAction(title: AlertActionConstants.buttonOk, style: .default, handler: nil)
        showAlert(title: alertTitle, message: alertMessage, actionPositive: alertAction)
    }
    
    /**
     Update the UI with received movie data. Shows the table view if the result is positive, otherwise hides the table view
     and shows the no results text label
     - Parameters: None
     - Returns: None
     */
    func updateUI(noResultText: String? = nil) {
        //stops showing the loading progress
        SVProgressHUD.dismiss()
        
        if movieViewModelArray.count == 0 {
            if let displayText = noResultText {
                showNoResultsText(displayText: displayText)
            } else {
                showNoResultsText(displayText: Constants.noResultText + searchBar.text!)
            }
            movieListTableView.isHidden = true
            
        } else {
            movieListTableView.isHidden = false
            if let label = noResultLabel {
                label.isHidden = true
            }
            movieListTableView.reloadData()
        }
    }
    
    /**
     Creates a no results text label if no movies are found by the query
     - Parameters: displayText: a String value to display as label text
     - Returns: None
     */
    func showNoResultsText(displayText: String) {
        if let label = noResultLabel {
            label.text = displayText
        } else {
            noResultLabel = UILabel(frame: CGRect(x: 0, y: searchBar.bounds.height + topDistance, width: view.frame.size.width - (UIViewMarginConstant.leadingMargin + UIViewMarginConstant.trailingMaring), height: view.frame.size.height/2))
            view.addSubview(noResultLabel!)
            noResultLabel!.center.x = view.center.x
            noResultLabel!.textColor = UIColor .white
            noResultLabel!.font = UIFont.systemFont(ofSize: 14.0)
            noResultLabel!.textAlignment = .center
            noResultLabel!.lineBreakMode = .byWordWrapping
            noResultLabel!.numberOfLines = 0
            noResultLabel!.text = displayText
        }
        
    }
    
    // MARK: alert methods
    
    func createNoInternetAlert() {
        let alertTitle = Constants.noInternetText
        let alertMessage = Constants.connectInternetText
        let positiveAction = UIAlertAction(title: AlertActionConstants.buttonOpenSettings,
                                           style: UIAlertAction.Style.default,
                                           handler: openSettings)
        let negativeAction = UIAlertAction(title: AlertActionConstants.buttonCancel,
                                           style: UIAlertAction.Style.default,
                                           handler: nil)
        
        showAlert(title: alertTitle, message: alertMessage, actionPositive: positiveAction, actionNegative: negativeAction)
    }
    
    func showAlert(title: String, message: String, actionPositive: UIAlertAction, actionNegative: UIAlertAction? = nil) {
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

// MARK - Search Bar delegate methods

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            if Connectivity.isConnectedToInternet {
                movieViewModelArray.removeAll(keepingCapacity: true) //removes previous search movie items
                moveSearchBarToTop()
                SVProgressHUD.show() //start showing the loading progress
                let refinedSearchString = searchBar.text?.condenseWhitespace()
                let encodedSearchString = Encoder.encodeInputSearchString(searchString: refinedSearchString!)
                if let finalURL = Encoder.buildURL(searchString: encodedSearchString) {
                    HTTPRequestCallToGetMovieData(url: finalURL) { _ in }
                    searchBar.endEditing(true)
                } else {
                    updateUI(noResultText: Constants.systemErrorText)
                }
                
            } else {
                createNoInternetAlert()
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
    
    // MARK: - Search Bar related other methods
    
    /**
     Moves search bar from center of the screen to top of the screen after initial search command
     - Parameters: none
     - Returns: None
     */
    func moveSearchBarToTop() {
        if searchBar.center.y == view.center.y {
            let searchBarYPosition = (view.bounds.height/2) - (topDistance + searchBar.bounds.height/2)
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: [],
                           animations: {
                            self.searchBarVerticalPosition.constant -= searchBarYPosition
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    // opens the settings page in iPhone
    func openSettings(alert: UIAlertAction!) {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: HTTP request call
    
    /**
     Initiates HTTP request to iTunes server, if success receives data in JSON format
     - Parameters: url: a String of URL
     - Returns: None
     */
    func HTTPRequestCallToGetMovieData(url: String, completion: @escaping(Bool)-> ()) {
        var httpRequest = URLRequest(url: NSURL.init(string: url)! as URL)
        httpRequest.httpMethod = HTTPMethod.get.rawValue
        httpRequest.timeoutInterval = TimeInterval(URLConstants.timeOutRequest)
        Alamofire.request(httpRequest).responseData { response in
            if response.result.isSuccess {
                print("Success Success Success Success Success")
                guard let data = response.result.value else { return }
                do {
                    let decoder = JSONDecoder()
                    self.movieResult = try decoder.decode(MovieResult.self, from: data)
                    DispatchQueue.main.async {
                        self.movieViewModelArray = self.movieResult!.results.map({return MovieViewModel(movie: $0)})
                        self.updateUI()
                    }
                } catch let jsonErr {
                    print("Failed to decode", jsonErr)
                }
            } else {
                print("Error: \(String(describing: response.result.error)) Error Error Error")
                if Connectivity.isConnectedToInternet {
                    self.updateUI(noResultText: Constants.ITunesServerErrorText)
                } else {
                    self.createNoInternetAlert()
                }
            }
        }
    }
}

