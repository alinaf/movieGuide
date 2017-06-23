//
//  DetailViewController.swift
//  movieGuide
//
//  Created by Alina Abidi on 6/21/17.
//  Copyright © 2017 Alina Abidi. All rights reserved.
//

import UIKit
import AlamofireImage
import UIImageColors


enum MovieKeys {
    static let title = "title"
    static let release_date = "release_date"
    static let overview = "overview"
    static let backDropPath = "backdrop_path"
     static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {

    
    @IBOutlet weak var backDropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie[MovieKeys.release_date] as? String
            overview.text = movie[MovieKeys.overview] as? String
            let backDropPathString = movie[MovieKeys.backDropPath] as! String
            let posterPathString = movie[MovieKeys.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backDropURL = URL(string: baseURLString + backDropPathString)!
            backDropImageView.af_setImage(withURL: backDropURL)
            
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
            
            let imageData = try? Data(contentsOf: backDropURL)
            let backDropImage = UIImage(data: imageData!)
            
            let colors = backDropImage?.getColors()
            titleLabel.textColor = colors?.primary
            backgroundView.backgroundColor = colors?.background
            releaseDateLabel.textColor = colors?.secondary
            overview.textColor = colors?.detail
            
            
            
            
            
            
            
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
