//
//  LoadMoreTableViewCell.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 2.07.2021.
//

import UIKit
protocol LoadMoreDelegate {
    func goToNextPage()
    func goToBackPage()

}
class LoadMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelPage: UILabel!
    
    var delegate:LoadMoreDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickNext(_ sender: Any) {
        delegate?.goToNextPage()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        delegate?.goToBackPage()
    }
    
}
