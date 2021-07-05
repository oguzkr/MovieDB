//
//  ViewController.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit
import SDWebImage
import SwiftGifOrigin

class ViewController: UIViewController, MovieDetailDelegate, LoadMoreDelegate {

    //MARK: VARIABLES & OUTLETS
    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    var delegate:LoadMoreDelegate?
    var movies = [MovieInfoModel]()
    var filteredMovies = [Result]()
    var searching = false

    var movieName = String()
    var movieVote = String()
    var movieVoteCount = String()
    var movieDesc = String()
    var movieBgUrl = String()
    var movieReleaseYear = String()
    var currentPage = 1
    var currentMovie : Result?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: AT START
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.array(forKey: "favMovies") == nil {
            defaults.set([], forKey: "favMovies")
        }
        setSearchBar()
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: CLICK EVENTS
    
    @IBAction func clickChangeView(_ sender: Any) {
        self.showAlert(titleInput: ":(", messageInput: "CollectionView için zamanım olmadı ama github profilimde başka bir repoda var")
    }
    

    //MARK: HELPER FUNCTIONS
    func getMovies(){
        network.getMovies(page: currentPage) { success in
            if success {
                self.movies = self.network.movies
                self.setTableView()
                print(self.movies)
            } else {
                self.showAlert(titleInput: "Success", messageInput: "Task failed successfully.")
            }
        }
    }
    
    func setTableView(){
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.MovieTableCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func setSearchBar(){
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
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
  
    
    //MARK: PROTOCOL FUNCTIONS
    func goToDetail() {
        performSegue(withIdentifier: Identifiers.detailPageSegue, sender: nil)
    }
    
    func favMovie() {
        if var favMovies = defaults.array(forKey: "favMovies") as? [Int] {
            if favMovies.contains(currentMovie!.id) {
                favMovies.removeAll(where: { $0 == currentMovie?.id })
                print("Removed: \(currentMovie?.title ?? "")")
            } else {
                favMovies.append(currentMovie!.id)
                print("Added: \(currentMovie?.title ?? "")")
            }
            defaults.set(favMovies, forKey: "favMovies")
        }
    }
    
    func goToNextPage() {
        if currentPage < movies.first!.total_pages {
            currentPage += 1
            getMovies()
        }
    }
    
    func goToBackPage() {
        if currentPage != 1 {
            currentPage -= 1
            getMovies()
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TABLEVIEW CUSTOMIZATIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredMovies.count
        } else {
            return (movies.first?.results.count)!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTVCell", for: indexPath) as! MovieTableViewCell
        let customBackground = "https://image.tmdb.org/t/p/w200/z2UtGA1WggESspi6KOXeo66lvLx.jpg"
        let bgColorView = UIView()


        
        bgColorView.backgroundColor = #colorLiteral(red: 0.1425223881, green: 0.1450759539, blue: 0.2010178939, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        cell.delegate = self
        
        if searching {
            cell.labelMovieName.text = filteredMovies[indexPath.row].title
            cell.labelMovieVote.text = "\(filteredMovies[indexPath.row].vote_average)/10"
            cell.labelMovieVoteCount.text = "\(filteredMovies[indexPath.row].vote_count)"
            cell.textViewMovieDesc.text = filteredMovies[indexPath.row].overview
            let backgroundImage = URL(string: ("\(Credential.BasePic)\(filteredMovies[indexPath.row].backdrop_path ?? customBackground)"))
            cell.imageViewMovieBg.sd_setImage(with: backgroundImage, placeholderImage: UIImage.gif(asset: "load"))
            cell.labelReleaseYear.text = "Release Date: \(filteredMovies[indexPath.row].release_date ?? "Bilinmiyor")"
            cell.movieId = filteredMovies[indexPath.row].id
            if let favMovies = defaults.array(forKey: "favMovies") as? [Int] {
                if favMovies.contains(filteredMovies[indexPath.row].id) {
                    cell.buttonFav.setImage(UIImage(named: "ic_fav_full"), for: .normal)
                } else {
                    cell.buttonFav.setImage(UIImage(named: "ic_fav_empty"), for: .normal)
                }
            }
        } else {
            cell.labelMovieName.text = movies.first!.results[indexPath.row].title
            cell.labelMovieVote.text = "\(movies.first!.results[indexPath.row].vote_average)/10"
            cell.labelMovieVoteCount.text = "\(movies.first!.results[indexPath.row].vote_count)"
            cell.textViewMovieDesc.text = movies.first!.results[indexPath.row].overview
            let backgroundImage = URL(string: ("\(Credential.BasePic)\(movies.first!.results[indexPath.row].backdrop_path ?? customBackground)"))
            cell.imageViewMovieBg.sd_setImage(with: backgroundImage, placeholderImage: UIImage.gif(asset: "load"))
            cell.labelReleaseYear.text = "Release Date: \(movies.first!.results[indexPath.row].release_date ?? "Bilinmiyor")"
            cell.movieId = movies.first!.results[indexPath.row].id
            if let favMovies = defaults.array(forKey: "favMovies") as? [Int] {
                if favMovies.contains(movies.first!.results[indexPath.row].id) {
                    cell.buttonFav.setImage(UIImage(named: "ic_fav_full"), for: .normal)
                } else {
                    cell.buttonFav.setImage(UIImage(named: "ic_fav_empty"), for: .normal)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            currentMovie = Result(adult: filteredMovies[indexPath.row].adult, backdrop_path: filteredMovies[indexPath.row].backdrop_path, genre_ids: filteredMovies[indexPath.row].genre_ids, id: filteredMovies[indexPath.row].id, original_language: filteredMovies[indexPath.row].original_language, original_title: filteredMovies[indexPath.row].original_title, overview: filteredMovies[indexPath.row].overview, popularity: filteredMovies[indexPath.row].popularity, poster_path: filteredMovies[indexPath.row].poster_path, release_date: filteredMovies[indexPath.row].release_date, title: filteredMovies[indexPath.row].title, video: filteredMovies[indexPath.row].video, vote_average: filteredMovies[indexPath.row].vote_average, vote_count: filteredMovies[indexPath.row].vote_count)
        } else {
            currentMovie = Result(adult: movies.first!.results[indexPath.row].adult, backdrop_path: movies.first!.results[indexPath.row].backdrop_path, genre_ids: movies.first!.results[indexPath.row].genre_ids, id: movies.first!.results[indexPath.row].id, original_language: movies.first!.results[indexPath.row].original_language, original_title: movies.first!.results[indexPath.row].original_title, overview: movies.first!.results[indexPath.row].overview, popularity: movies.first!.results[indexPath.row].popularity, poster_path: movies.first!.results[indexPath.row].poster_path, release_date: movies.first!.results[indexPath.row].release_date, title: movies.first!.results[indexPath.row].title, video: movies.first!.results[indexPath.row].video, vote_average: movies.first!.results[indexPath.row].vote_average, vote_count: movies.first!.results[indexPath.row].vote_count)
        }
        
        movieBgUrl = currentMovie!.poster_path
        movieName = currentMovie!.title
        movieVote = "\(currentMovie!.vote_average)/10"
        movieVoteCount = "\(currentMovie!.vote_count)"
        movieDesc = currentMovie!.overview
        movieReleaseYear =  currentMovie!.release_date!
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = Bundle.main.loadNibNamed("TableViewFooter", owner: self, options: nil)?.last as! TableViewFooter
        footerView.delegate = self
        footerView.labelPage.text = "\(movies.first!.page)/\(movies.first!.total_pages)"
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = (movies.first?.results.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}))!
        searching = true
        if searchBar.searchTextField.text == "" {
            searching = false
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
