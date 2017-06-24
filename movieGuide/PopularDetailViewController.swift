//
//  PopularDetailViewController.swift
//  movieGuide
//
//  Created by Alina Abidi on 6/23/17.
//  Copyright © 2017 Alina Abidi. All rights reserved.
//

import UIKit
import AlamofireImage
import UIImageColors


class PopularDetailViewController: UIViewController {
    
    
    @IBOutlet weak var trendingLabel: UILabel!
    
    @IBOutlet weak var backDropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    var movie: [String: Any]?
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            nowPlayingLabel.text = movie[MovieKeys.release_date] as? String
            overview.text = movie[MovieKeys.overview] as? String
            
            let trendingNumber = counter + 1
            trendingLabel.text = "Trending # " + "\(String(describing: trendingNumber))"
            
            
            
            
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
            nowPlayingLabel.textColor = colors?.secondary
            overview.textColor = colors?.detail
            trendingLabel.textColor = colors!.primary
            }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
