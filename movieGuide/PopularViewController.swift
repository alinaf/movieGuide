//
//  PopularViewController.swift
//  movieGuide
//
//  Created by Alina Abidi on 6/23/17.
//  Copyright © 2017 Alina Abidi. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [[String: Any]] = []
    var isMoreDataLoading = false
    var pageCount = 1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPath = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPath)!
            cell.posterImageView.af_setImage(withURL: posterURL)
            
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
    
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
            isMoreDataLoading = true
            pageCount += 1
            print(pageCount)
            fetchMoreMovies()
            }
        }
    
    
    }
    
    func fetchMoreMovies() {
        
        let pageCountString = String(pageCount)
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3a8164978916a740e3977e79afd28289&page=" + pageCountString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns (they are asynchronus)
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies += movies
                self.collectionView.reloadData()
    
                
            }
            
        }
        
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchMovies()

        // Do any additional setup after loading the view.
    }

    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3a8164978916a740e3977e79afd28289&page=1")!
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
                self.collectionView.reloadData()
               // self.refreshControl.endRefreshing()
                
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! PopularDetailViewController
            detailViewController.movie = movie
            detailViewController.counter = indexPath.row
        }
    }

}
