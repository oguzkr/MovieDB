//
//  MovieTableViewCell.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit
protocol MovieDetailDelegate {
    func goToDetail()
    func favMovie()
}
class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewMovieBg: UIImageView!
    @IBOutlet weak var textViewMovieDesc: UITextView!
    @IBOutlet weak var movieInfo: UIView!
    @IBOutlet weak var imageMovieInfo: UIView!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelMovieVote: UILabel!
    @IBOutlet weak var labelMovieVoteCount: UILabel!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var buttonFav: UIButton!
    
    var delegate:MovieDetailDelegate?
    var movieId = Int()
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setContentToBottom(animated: false)
    }
    
    @IBAction func clickFav(_ sender: Any) {
        delegate?.favMovie()
        
        if let favMovies = defaults.array(forKey: "favMovies") as? [Int] {
            if favMovies.contains(movieId) {
                buttonFav.setImage(UIImage(named: "ic_fav_full"), for: .normal)
            } else {
                buttonFav.setImage(UIImage(named: "ic_fav_empty"), for: .normal)
            }
        }
    }
    
    @IBAction func clickInfo(_ sender: Any) {
        setContentToBottom(animated: true)
        delegate?.goToDetail()
    }
    
    @IBAction func clickClose(_ sender: Any) {
        setContentToBottom(animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            setContentToTop()
        } else {
            setContentToBottom(animated: true)
        }
    }

    func setContentToBottom(animated: Bool){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.movieInfo.translatesAutoresizingMaskIntoConstraints = true
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.movieInfo.frame = CGRect(x: 5, y: 165, width: screenWidth - 10, height: 190)
            }
        } else {
            self.movieInfo.frame = CGRect(x: 5, y: 165, width: screenWidth - 10, height: 190)
        }
        
    }
    
    func setContentToTop(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.movieInfo.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.5) {
            self.movieInfo.frame = CGRect(x: 5, y: 5, width: screenWidth - 10, height: 190)
        }
    }
    
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            tableView.deselectAllRows(animated: false)
        }
    }
}
