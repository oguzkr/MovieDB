//
//  ViewController.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    var movies = [MovieInfoModel]()
    var filteredMovies = [MovieInfoModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.getMovies(page: 1) { success in
            if success {
                self.movies = self.network.movies
                print(self.movies)
            } else {
                self.showAlert(titleInput: "Success", messageInput: "Task failed successfully.")
            }
        }
    }


}

