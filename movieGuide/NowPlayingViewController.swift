//
//  NowPlayingViewController.swift
//  movieGuide
//
//  Created by Alina Abidi on 6/21/17.
//  Copyright © 2017 Alina Abidi. All rights reserved.
//

import UIKit
import AlamofireImage
import KRProgressHUD


class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.show()

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        tableView.dataSource = self
        fetchMovies()
        

    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMovies()
    }
    
    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=3a8164978916a740e3977e79afd28289")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns (they are asynchronus)
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                KRProgressHUD.dismiss()
            }
            
        }
        
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Double
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.ratingLabel.text = "\(String(describing: rating))"
        
       let myRed = UIColor(red:0.68, green:0.17, blue:0.17, alpha:1.0)
       let myGreen = UIColor(red:0.22, green:0.59, blue:0.30, alpha:1.0)
        
        if rating >= 7.00 {
            cell.ratingLabel.textColor = myGreen
        } else if rating < 6.00 {
            cell.ratingLabel.textColor = myRed
        } else {
            cell.ratingLabel.textColor = UIColor.black
        }
        
        
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
