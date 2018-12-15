//
//  MovieCollectionViewCell.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 11/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionCell"
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    func refresh(with movie: Movie) {
        if let thumbImageData = movie.thumbImage {
            thumbImageView.image = UIImage(data: thumbImageData)
        }
        titleLabel.text = movie.title
        titleLabel.adjustsFontSizeToFitWidth = true
        infoLabel.text = movie.movieInfoForCollection
        infoLabel.adjustsFontSizeToFitWidth = true
        dateLabel.text = movie.dateForTable
        gradeImageView.image = UIImage(named: movie.gradeString)
    }
}
