//
//  ViewController.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit
import SDWebImage
import SwiftGifOrigin

class ViewController: UIViewController {
    
    //MARK: VARIABLES & OUTLETS
    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    var movies = [MovieInfoModel]()
    var filteredMovies = [MovieInfoModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: AT START
    override func viewDidLoad() {
        super.viewDidLoad()
        network.getMovies(page: 1) { success in
            if success {
                self.movies = self.network.movies
                self.setTableView()
                self.tableView.reloadData()
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
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieTVCell")
        tableView.delegate = self
        tableView.dataSource = self
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
        
        cell.labelMovieName.text = movies.first!.results[indexPath.row].title
        cell.labelMovieVote.text = "\(movies.first!.results[indexPath.row].vote_average)/10"
        cell.labelMovieVoteCount.text = "\(movies.first!.results[indexPath.row].vote_count)"
        cell.textViewMovieDesc.text = movies.first!.results[indexPath.row].overview
        cell.imageViewMovieBg.sd_setImage(with: backgroundImage, placeholderImage: UIImage.gif(asset: "load"))
        
        return cell
    }
    

}
