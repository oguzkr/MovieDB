//
//  TableViewFooter.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 2.07.2021.
//

import UIKit

protocol LoadMoreDelegate {
    func goToNextPage()
    func goToBackPage()
}

class TableViewFooter: UIView {
    
    var delegate:LoadMoreDelegate?
    
    @IBOutlet weak var labelPage: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonBack: UIButton!

    @IBAction func clickNext(_ sender: Any) {
        delegate?.goToNextPage()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        delegate?.goToBackPage()
    }
    
}
