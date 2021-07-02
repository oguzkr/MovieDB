//
//  ViewController.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit
import SDWebImage
import SwiftGifOrigin

class ViewController: UIViewController, MovieDetailDelegate {

    //MARK: VARIABLES & OUTLETS
    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    var movies = [MovieInfoModel]()
    var filteredMovies = [MovieInfoModel]()
    
    var movieName = String()
    var movieVote = String()
    var movieVoteCount = String()
    var movieDesc = String()
    var movieBgUrl = String()
    var movieReleaseYear = String()

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: AT START
    override func viewDidLoad() {
        super.viewDidLoad()
        network.getMovies(page: 1) { success in
            if success {
                self.movies = self.network.movies
                self.setTableView()
                self.tableView.reloadData()
                print(self.movies)
            } else {
                self.showAlert(titleInput: "Success", messageInput: "Task failed successfully.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    //MARK: CLICK EVENTS
    
    //MARK: HELPER FUNCTIONS
    func setTableView(){
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.MovieTableCell)

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func goToDetail() {
        performSegue(withIdentifier: Identifiers.detailPageSegue, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MovieDetailViewController {
            let detailViewController = segue.destination as? MovieDetailViewController
            detailViewController?.movieName = movieName
            detailViewController?.movieVote = movieVote
            detailViewController?.movieVoteCount = movieVoteCount
            detailViewController?.movieDesc = movieDesc
            detailViewController?.movieBgUrl = movieBgUrl
            detailViewController?.movieReleaseYear = movieReleaseYear
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TABLEVIEW CUSTOMIZATIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movies.first?.results.count)!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTVCell", for: indexPath) as! MovieTableViewCell
        let customBackground = "https://image.tmdb.org/t/p/w200/z2UtGA1WggESspi6KOXeo66lvLx.jpg"
        let backgroundImage = URL(string: ("\(Credential.BasePic)\(movies.first!.results[indexPath.row].backdrop_path ?? customBackground)"))
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.1425223881, green: 0.1450759539, blue: 0.2010178939, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        cell.delegate = self
        cell.labelMovieName.text = movies.first!.results[indexPath.row].title
        cell.labelMovieVote.text = "\(movies.first!.results[indexPath.row].vote_average)/10"
        cell.labelMovieVoteCount.text = "\(movies.first!.results[indexPath.row].vote_count)"
        cell.textViewMovieDesc.text = movies.first!.results[indexPath.row].overview
        cell.imageViewMovieBg.sd_setImage(with: backgroundImage, placeholderImage: UIImage.gif(asset: "load"))
        cell.labelReleaseYear.text = "Release Date: \(movies.first!.results[indexPath.row].release_date ?? "Bilinmiyor")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieBgUrl = movies.first!.results[indexPath.row].poster_path
        movieName = movies.first!.results[indexPath.row].title
        movieVote = "\(movies.first!.results[indexPath.row].vote_average)/10"
        movieVoteCount = "\(movies.first!.results[indexPath.row].vote_count)"
        movieDesc = movies.first!.results[indexPath.row].overview
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = TableViewFooter.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    

}
