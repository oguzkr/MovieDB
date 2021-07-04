//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 1.07.2021.
//

import UIKit
import SwiftGifOrigin
import SDWebImage

class MovieDetailViewController: UIViewController {

    
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var imageMoviePoster: RoundedImageView!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var labelVote: UILabel!
    @IBOutlet weak var labelVoteCount: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
    
    var movieName = String()
    var movieVote = String()
    var movieVoteCount = String()
    var movieDesc = String()
    var movieBgUrl = String()
    var movieReleaseYear = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieInfo()
    }
    
    func setMovieInfo(){
        labelMovieName.text = movieName
        labelVote.text = "\(movieVote)"
        labelVoteCount.text = movieVoteCount
        labelReleaseYear.text = "Release Year: \(movieReleaseYear)"
        textViewDesc.text = movieDesc
        let backgroundImage = URL(string: ("\(Credential.BasePic)\(movieBgUrl)"))
        imageMoviePoster.sd_setImage(with: backgroundImage, placeholderImage: UIImage.gif(asset: "load"))
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
