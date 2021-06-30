//
//  UITableView.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import UIKit

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { deselectRow(at: indexPath, animated: animated) }
    }
}
