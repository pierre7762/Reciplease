//
//  LoadingCell.swift
//  Reciplease
//
//  Created by Pierre on 13/12/2021.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        activityIndicator.color = UIColor.white
    }
    
}
