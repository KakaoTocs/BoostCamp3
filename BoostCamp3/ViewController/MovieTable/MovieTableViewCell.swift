//
//  MovieTableViewCell.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 10/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identifier: String = "MovieTableCell"

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refresh(with movie: Movie) {
        if let thumbImageData = movie.thumbImage {
            thumbImageView.image = UIImage(data: thumbImageData)
        }
        titleLabel.text = movie.title
        titleLabel.adjustsFontSizeToFitWidth = true
        infoLabel.text = movie.movieInfoForTable
        infoLabel.adjustsFontSizeToFitWidth = true
        dateLabel.text = movie.date
        gradeImageView.image = UIImage(named: movie.gradeString)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
